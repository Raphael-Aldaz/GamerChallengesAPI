import { Request, Response } from "express"
import { prisma } from "../../../prisma/index.js"
import { NotFoundError } from "../../../lib/error.js"

export const getAllGamesTypes = async (req: Request, res: Response) => {
  try {
    const allGamesTypes = await prisma.type.findMany({})
    return res.status(200).json({ allGamesTypes })
  } catch (error) {
    throw new NotFoundError("Types not found")
  }
}
