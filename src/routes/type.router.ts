import { Router } from "express"
import * as typeController from "../controllers/TypeController/TypeController.js"
const router = Router()
router.get("/", typeController.getAllGamesTypes)
export default router
