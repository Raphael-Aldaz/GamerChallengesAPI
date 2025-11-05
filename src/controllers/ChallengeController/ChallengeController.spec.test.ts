import { strictEqual, ok, deepStrictEqual } from "assert"
import { describe, it, before } from "node:test"
import { prismaTest } from "../../../test/config/prisma-test.js"
import { Challenge } from "@prisma/client"

describe("Challenge API", () => {
  // Variables partagées entre tous les tests
  let allChallengesFromDB: any[] = []
  let expectedNewestChallenges: any[] = []
  let expectedPopularChallenges: any[] = []

  before(async () => {
    allChallengesFromDB = await prismaTest.challenge.findMany({
      include: {
        likes: true,
        user: true,
      },
    })

    // Préparer les données triées pour les nouveaux challenges
    expectedNewestChallenges = [...allChallengesFromDB].sort((a, b) => b.created_at.getTime() - a.created_at.getTime())

    // Préparer les données triées pour les challenges populaires
    expectedPopularChallenges = [...allChallengesFromDB].sort((a, b) => b.likes.length - a.likes.length)
  })

  describe("Newest Challenges", () => {
    it("should respond to GET /challenges/newest", async () => {
      const newest = await fetch("http://localhost:7357/api/challenges/newest")
      strictEqual(newest.status, 200)
    })

    it("should return the good number of challenges", async () => {
      const newest = await fetch("http://localhost:7357/api/challenges/newest")
      const data = await newest.json()
      ok(data.newestChallenges, "newestChallenges should exist")
      strictEqual(Array.isArray(data.newestChallenges), true)
      strictEqual(data.newestChallenges.length, 4)
    })

    it("should return 4 challenges sorted by creation date (desc)", async () => {
      const res = await fetch("http://localhost:7357/api/challenges/newest")
      const data = await res.json()
      const challenges = data.newestChallenges

      // Compare les IDs dans l'ordre en utilisant les données déjà chargées
      const receivedIds = challenges.map((c: Challenge) => c.challenge_id)
      const expectedIds = expectedNewestChallenges.slice(0, 4).map((c) => c.challenge_id)

      deepStrictEqual(receivedIds, expectedIds)
    })
  })

  describe("Popular Challenges", () => {
    it("should respond to GET /challenges/popular", async () => {
      const response = await fetch("http://localhost:7357/api/challenges/popular")
      strictEqual(response.status, 200)
    })

    it("should return the good number of popular challenges", async () => {
      const response = await fetch("http://localhost:7357/api/challenges/popular")
      const data = await response.json()

      ok(data.populareChallenges, "populareChallenges should exist")
      strictEqual(Array.isArray(data.populareChallenges), true)
      strictEqual(data.populareChallenges.length, 5)
    })

    it("should return 5 challenges sorted by likes count (desc)", async () => {
      const res = await fetch("http://localhost:7357/api/challenges/popular")
      const data = await res.json()
      const challenges = data.populareChallenges
      for (let i = 0; i < challenges.length - 1; i++) {
        const currentLikesCount = challenges[i].likes?.length || 0
        const nextLikesCount = challenges[i + 1].likes?.length || 0

        ok(
          currentLikesCount >= nextLikesCount,
          `Challenge ${i} should have more or equal likes than challenge ${i + 1}`
        )
      }
    })

    it("should return challenges with likes included", async () => {
      const res = await fetch("http://localhost:7357/api/challenges/popular")
      const data = await res.json()
      const challenges = data.populareChallenges

      ok(challenges.length > 0, "Should have at least one challenge")

      challenges.forEach((challenge: any, index: number) => {
        ok(challenge._count.likes !== undefined, `Challenge ${index} should have likes property`)
      })
    })

    it("should return challenges with user information included", async () => {
      const res = await fetch("http://localhost:7357/api/challenges/popular")
      const data = await res.json()
      const challenges = data.populareChallenges

      ok(challenges.length > 0, "Should have at least one challenge")

      challenges.forEach((challenge: any, index: number) => {
        ok(challenge.user !== undefined, `Challenge ${index} should have user property`)
        ok(challenge.user.eamil || challenge.user.email, `Challenge ${index} user should have an email`)
      })
    })

    it("should return maximum 5 challenges even if more exist", async () => {
      const res = await fetch("http://localhost:7357/api/challenges/popular")
      const data = await res.json()

      ok(data.populareChallenges.length <= 5, "Should return at most 5 challenges")
    })
  })
  describe("Challenges by Game ID", () => {
    it("should respond to GET /challenges?gameId=${gameId}", async () => {
      const gameId = 1
      const response = await fetch(`http://localhost:7357/api/challenges?gameId=${gameId}`)
      strictEqual(response.status, 200)
    })
    it("should return 404 for non-existent game ID", async () => {
      const response = await fetch("http://localhost:7357/api/challenges?gameId=99999")
      strictEqual(response.status, 404)
    })

    it("should return 400 for invalid game ID", async () => {
      const response = await fetch("http://localhost:7357/api/challenges?gameId=invalid")
      strictEqual(response.status, 400)
    })
  })
})
