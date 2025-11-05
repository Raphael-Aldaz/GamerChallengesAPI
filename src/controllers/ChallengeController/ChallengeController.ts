import { Prisma } from "@prisma/client"
import { prisma } from "../../../prisma/index.js"
import { Request, Response } from "express"
import { NotFoundError } from "../../../lib/error.js"
import { validateId } from "../../../utils/validateId.js"
const challengeInclude: Prisma.ChallengeInclude = {
  _count: {
    select: {
      likes: true,
    },
  },
  game: {
    include: {
      gameImages: {
        select: {
          media: {
            select: {
              path: true,
            },
          },
        },
      },
    },
  },
  user: {
    select: {
      email: true,
      user_avatar: {
        select: {
          media: {
            select: {
              path: true,
            },
          },
        },
      },
    },
  },
}
export const getNewestChallenges = async (req: Request, res: Response) => {
  const newestChallenges = await prisma.challenge.findMany({
    include: challengeInclude,
    take: 4,
    orderBy: {
      created_at: "desc",
    },
  })
  if (!newestChallenges || newestChallenges.length === 0) {
    throw new NotFoundError("No newest challenges found")
  }
  return res.status(200).json({ newestChallenges })
}
export const getMostPopulareChallenges = async (req: Request, res: Response) => {
  const populareChallenges = await prisma.challenge.findMany({
    include: challengeInclude,
    take: 5,
    orderBy: {
      likes: {
        _count: "desc",
      },
    },
  })
  if (!populareChallenges || populareChallenges.length === 0) {
    throw new NotFoundError("No popular challenges found")
  }
  return res.status(200).json({ populareChallenges })
}
export const getChallengesByGameId = async (req: Request, res: Response) => {
  const { gameId } = req.query
  const valideId = validateId(gameId)

  const challengesByGame = await prisma.challenge.findMany({
    where: { game_id: valideId },
    include: challengeInclude,
  })
  if (!challengesByGame || challengesByGame.length === 0) {
    throw new NotFoundError("No challenges found for this game")
  }
  return res.json({ challengesByGame })
}
export const getFeaturedChallenges = async (req: Request, res: Response) => {
  const count = 3

  const totalChallenges = await prisma.challenge.count()
  if (totalChallenges === 0) {
    throw new NotFoundError("No challenges available")
  }
  const skipValue = totalChallenges % count
  const featuredChallenges = await prisma.challenge.findMany({
    include: challengeInclude,
    orderBy: { challenge_id: "desc" },
    take: 5,
    skip: skipValue,
  })
  if (!featuredChallenges || featuredChallenges.length === 0) {
    throw new NotFoundError("Featured challenges not found")
  }
  return res.status(200).json({ featuredChallenges })
}
export const newChallenge = async (req: Request, res: Response) => {}
