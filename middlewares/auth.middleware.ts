import { Role } from "@prisma/client"
import { NextFunction, Request, Response } from "express"
import jwt, { Secret } from "jsonwebtoken"
import { getJwtSecret } from "../lib/token.js"
import { UnauthorizedError } from "../lib/error.js"
import { prisma } from "../prisma/index.js"
import { config } from "../config.js"
import { logger } from "../lib/log.js"
export interface JwtPayload {
  userId: number
}

export const verifyToken = (req: Request, res: Response, next: NextFunction) => {
  try {
    const token = req.cookies.accessToken
    const jwtSecret = config.server.jwtSecret

    if (!token) {
      throw new UnauthorizedError("No authentication token provided")
    }

    const decoded = jwt.verify(token, jwtSecret as Secret) as JwtPayload

    req.userId = decoded.userId
    console.log(req.userId, " ", decoded)
    next()
  } catch (error) {
    if (error instanceof jwt.JsonWebTokenError) {
      logger.warn("Invalid authentication token")
      throw new UnauthorizedError("Invalid authentication token")
    }
    if (error instanceof jwt.TokenExpiredError) {
      logger.warn("Authentication token expired")
      throw new UnauthorizedError("Authentication token expired")
    }
    throw error
  }
}
