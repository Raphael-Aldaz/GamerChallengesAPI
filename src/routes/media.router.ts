import { Router } from "express"
import { MediaController } from "../controllers/MediaController/MediaController.js"
const mediaController = new MediaController()
const router = Router()
router.get("/", (req, res) => mediaController.getMedia(req, res))
export default router
