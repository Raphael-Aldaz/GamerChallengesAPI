import { Router } from "express"
import challengeRoutes from "./routes/challenge.router.js"
import uploadRoutes from "./routes/upload.router.js"
import mediaRoutes from "./routes/media.router.js"
import authRoutes from "./routes/auth.router.js"
import typeRoutes from "./routes/type.router.js"
import gameRoutes from "./routes/game.router.js"
export const router = Router()
router.use("/challenges", challengeRoutes)
router.use("/upload", uploadRoutes)
router.use("/media", mediaRoutes)
router.use("/auth", authRoutes)
router.use("/types", typeRoutes)
router.use("/games", gameRoutes)
