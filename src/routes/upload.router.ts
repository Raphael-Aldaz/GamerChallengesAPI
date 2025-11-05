import { Request, Response, Router } from "express"
import {
  handleMulterError,
  uploadImage,
  uploadMultiple,
  uploadVideo,
} from "../../upload/upload.config.js"

const router = Router()
router.post(
  "/image",
  uploadImage,
  handleMulterError,
  (req: Request, res: Response) => {
    if (!req.file) {
      return res.status(400).json({ error: "Aucun fichier uploadé" })
    }
    res.json({ file: req.file })
  }
)
router.post(
  "/video",
  uploadVideo,
  handleMulterError,
  (req: Request, res: Response) => {
    if (!req.file) {
      return res.status(400).json({ error: "Aucun fichier uploadé" })
    }
    res.json({ file: req.file })
  }
)
router.post(
  "/multiples",
  uploadMultiple,
  handleMulterError,
  (req: Request, res: Response) => {
    const files = req.files as { [fieldname: string]: Express.Multer.File[] }

    if (!files.images && !files.videos) {
      return res.status(400).json({ error: "Aucun fichier uploadé" })
    }

    res.json({
      message: "Fichiers uploadés avec succès",
      images:
        files.images?.map((f) => ({
          filename: f.filename,
          path: f.path,
          size: f.size,
        })) || [],
      videos:
        files.videos?.map((f) => ({
          filename: f.filename,
          path: f.path,
          size: f.size,
        })) || [],
    })
  }
)
export default router
