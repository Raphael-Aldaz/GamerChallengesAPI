import { Router } from "express"
import * as gamesController from "../controllers/GameController/GameController.js"
const router = Router()
router.get("/gamesWithMoreChallenges", gamesController.getGameWithMostChallenges)
export default router
