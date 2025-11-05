import { Role, User } from "@prisma/client"
import BaseController from "../BaseController.js"
import { prisma } from "../../../prisma/index.js"
import { Request, Response } from "express"
import { loginSchema, registerSchema } from "../../schemas/auth.schema.js"
import argon2 from "argon2"
import { BadRequestError, ConflictError, ForbiddenError, UnauthorizedError } from "../../../lib/error.js"
import { generateAuthenticationTokens } from "../../../lib/token.js"
import { config } from "../../../config.js"
import { logger } from "../../../lib/log.js"
interface Token {
  token: string
  type: string
  expiresInMS: number
}

// export default class AuthController extends BaseController<User, "user_id"> {
//   constructor() {
//     super(prisma.user, "user_id")
//   }
//   async login(req: Request, res: Response) {
//     const { email, password } = await loginSchema.parseAsync(req.body)

//     const user = await prisma.user.findFirst({
//       where: { email },
//       include: {
//         roles: {
//           select: {
//             role: {
//               select: {
//                 role_name: true,
//               },
//             },
//           },
//         },
//       },
//     })
//     if (!user) {
//       throw new UnauthorizedError("Email and password not matching")
//     }
//     const isMatching = await argon2.verify(user.password, password)
//     if (!isMatching) {
//       throw new UnauthorizedError("Email and password not matching")
//     }
//     const accessToken = await this.generateAndSetTokens(res, user)

//     return res.status(200).json({
//       message: "Connecté avec succès",
//       accessToken: accessToken,
//       user: {
//         id: user.user_id,
//         pseudo: user.pseudo,
//         email: user.email,
//         role: user.roles,
//       },
//     })
//   }
//   async logout(req: Request, res: Response) {
//     await this.deleteTokenAndCookies(req, res)
//     return res.status(200).json({
//       status: 200,
//       message: "Successfully logged out",
//     })
//   }
//   async softDeleteUser(req: JwtRequest, res: Response) {
//     const userId = Number(req.params.userId)
//     if (userId !== req.user!.user_id) {
//       throw new ForbiddenError("Action non authorizé")
//     }
//     const randomHash = await argon2.hash(Math.random().toString())
//     const userDeleted = await this.update(userId, {
//       pseudo: `deleted_user(${userId})`,
//       email: `deleted_user_${userId}_${Date.now()}@deleted.com`,
//       password: randomHash,
//       avatar: "",
//       deleted_at: new Date(),
//     })
//     await this.deleteTokenAndCookies(req, res)

//     return res.sendStatus(204)
//   }

//   async register(req: Request, res: Response) {
//     const { email, pseudo, password, confirm, roles } = await registerSchema.parseAsync(req.body)

//     if (password !== confirm) {
//       throw new BadRequestError("Les mots de passes ne correspondent pas")
//     }
//     const alreadyExistingUser = await prisma.user.findMany({
//       where: { OR: [{ email }, { pseudo }] },
//       select: { email: true, pseudo: true },
//     })

//     const errors = alreadyExistingUser.reduce<Record<string, string>>((acc, user) => {
//       if (user.email === email) acc.email = "Email déjà utilisé"
//       if (user.pseudo === pseudo) acc.pseudo = "Pseudo déjà utilisé"
//       return acc
//     }, {})
//     if (Object.keys(errors).length) {
//       return res.status(409).json({ errors })
//     }
//     const hashedPassword = await argon2.hash(password)

//     const allRoles = await prisma.role.findMany({
//       where: { role_name: { in: roles } },
//     })

//     if (allRoles.length === 0) {
//       throw new Error(`Le rôle "${allRoles}" n'existe pas`)
//     }
//     const user = await prisma.user.create({
//       data: {
//         pseudo,
//         email,
//         password: hashedPassword,
//         roles: {
//           create: allRoles.map((role) => ({
//             role: { connect: { role_id: role.role_id } },
//           })),
//         },
//       },
//     })
//     if (!user) {
//       throw new BadRequestError("Erreur creation user")
//     }
//     const accessToken = await this.generateAndSetTokens(res, user)
//     return res.status(200).json({
//       message: "Connecté avec succès",
//       accessToken: accessToken,
//       user: {
//         id: user.user_id,
//         pseudo: user.pseudo,
//         email: user.email,
//         roles: allRoles,
//       },
//     })
//   }
//   async generateAndSetTokens(res: Response, user: User) {
//     const { accessToken, refreshToken } = await generateAuthenticationTokens(user)
//     await this.replaceRefreshTokenInDatabase(refreshToken, user)
//     this.setAccesTokenCookie(res, accessToken)
//     this.setRefreshTokenCookie(res, refreshToken)
//     return accessToken
//   }
//   async replaceRefreshTokenInDatabase(refreshToken: Token, user: User) {
//     await prisma.refreshToken.deleteMany({ where: { user_id: user.user_id } })
//     await prisma.refreshToken.create({
//       data: {
//         token: refreshToken.token,
//         user_id: user.user_id,
//         expired_at: new Date(Date.now() + refreshToken.expiresInMS),
//       },
//     })
//   }
//   setAccesTokenCookie(res: Response, accessToken: Token) {
//     res.cookie("accessToken", accessToken.token, {
//       httpOnly: true,
//       maxAge: accessToken.expiresInMS,
//       secure: config.server.secure,
//     })
//   }
//   setRefreshTokenCookie(res: Response, refreshToken: Token) {
//     res.cookie("refreshToken", refreshToken.token, {
//       httpOnly: true,
//       maxAge: refreshToken.expiresInMS,
//       secure: config.server.secure,
//       path: "/api/auth/",
//     })
//   }
//   async deleteTokenAndCookies(req: Request, res: Response) {
//     const rawToken = req.cookies?.refreshToken
//     if (rawToken) {
//       await prisma.refreshToken.deleteMany({ where: { token: rawToken } })
//     }

//     res.clearCookie("accessToken", {
//       httpOnly: true,
//       secure: config.server.secure,
//       sameSite: "lax",
//     })

//     res.clearCookie("refreshToken", {
//       httpOnly: true,
//       secure: config.server.secure,
//       sameSite: "lax",
//       path: "/api/auth/",
//     })
//   }
// }
export const login = async (req: Request, res: Response) => {
  const { email, password } = await loginSchema.parseAsync(req.body)

  const user = await prisma.user.findUnique({ where: { email } })
  if (!user) {
    logger.error("Authentication attempt with unknown email", { email })
    throw new UnauthorizedError("Invalid credentials")
  }
  const isMatching = await argon2.verify(user.password, password)
  if (!isMatching) {
    logger.warn("Authentication attempt with email", { email })
    throw new UnauthorizedError("Invalid credentials")
  }

  const { accessToken, refreshToken } = await generateAuthenticationTokens(user)
  await replaceRefreshTokenInDatabase(refreshToken, user)
  setAccesTokenCookie(res, accessToken)
  setRefreshTokenCookie(res, refreshToken)

  res.status(200).json({ accessToken, refreshToken })
}
export const logout = async (req: Request, res: Response) => {
  const refreshToken = req.cookies.refreshToken
  if (refreshToken) {
    await prisma.refreshToken.deleteMany({
      where: { token: refreshToken },
    })
  }
  res.clearCookie("accessToken", {
    httpOnly: true,
    secure: config.server.secure,
    sameSite: "lax",
  })
  res.clearCookie("refreshToken", {
    httpOnly: true,
    secure: config.server.secure,
    path: "/api/auth/refresh",
    sameSite: "lax",
  })

  res.status(204).send()
}
export const getAuthenticatedUser = async (req: Request, res: Response) => {
  const userId = req.userId
  if (!userId) {
    throw new UnauthorizedError("User ID is missing from request")
  }
  // Récupérer l'utilisteur en BDD (sans son MDP)
  const user = await prisma.user.findUnique({
    where: { user_id: userId },
    omit: { password: true },
  })
  if (!user) {
    throw new UnauthorizedError("JWT payload does not match any user")
  }

  // Renvoie des données controlées
  res.json(user)
}
const replaceRefreshTokenInDatabase = async (refreshToken: Token, user: User) => {
  await prisma.$transaction([
    prisma.refreshToken.deleteMany({ where: { user_id: user.user_id } }),
    prisma.refreshToken.create({
      data: {
        token: refreshToken.token,
        user_id: user.user_id,
        created_at: new Date(),
        expired_at: new Date(new Date().valueOf() + refreshToken.expiresInMS),
      },
    }),
  ])
}
const setAccesTokenCookie = (res: Response, accessToken: Token) => {
  res.cookie("accessToken", accessToken.token, {
    httpOnly: true,
    maxAge: accessToken.expiresInMS,
    secure: config.server.secure,
    sameSite: "lax",
  })
}
const setRefreshTokenCookie = (res: Response, refreshToken: Token) => {
  res.cookie("refreshToken", refreshToken.token, {
    httpOnly: true,
    maxAge: refreshToken.expiresInMS,
    secure: config.server.secure,
    path: "/api/auth/refresh",
    sameSite: "lax",
  })
}
