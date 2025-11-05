import { Request, Response } from "express"
import { prisma } from "../../../prisma/index.js"

export const getGameWithMostChallenges = async (req: Request, res: Response) => {
  try {
    const games = await prisma.game.findMany({
      select: {
        title: true,
        _count: {
          select: { challenges: true }, // compte le nombre de challenges
        },
      },
      orderBy: {
        challenges: {
          _count: "desc", // trie par nombre de challenges
        },
      },
      take: 5,
    })

    return res.status(200).json({ games })
  } catch (error) {
    console.error(error)
    return res.status(500).json({ message: "Erreur serveur" })
  }
}
