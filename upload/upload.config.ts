import { Request, Response, NextFunction } from "express"
import multer from "multer"
import crypto from "node:crypto"
import path from "node:path"
import fs from "node:fs"

// Configuration du stockage (compatible Windows)
const storage = multer.diskStorage({
  destination: (req, file, callback) => {
    const baseFolder = file.mimetype.startsWith("image/")
      ? path.join("uploads", "images")
      : path.join("uploads", "videos")

    const currentDate = new Date()
    const year = currentDate.getFullYear()
    const month = String(currentDate.getMonth() + 1).padStart(2, "0")
    const day = String(currentDate.getDate()).padStart(2, "0")

    // Utiliser path.join pour tous les chemins (Windows-safe)
    const fullPath = path.join(baseFolder, String(year), month, day)

    // Créer le dossier s'il n'existe pas
    try {
      fs.mkdirSync(fullPath, { recursive: true })
      callback(null, fullPath)
    } catch (error) {
      callback(error as Error, fullPath)
    }
  },
  filename: (req, file, callback) => {
    const randomName = crypto.randomBytes(16).toString("hex")
    const ext = path.extname(file.originalname)
    const uniqueName = `${randomName}${ext}`
    callback(null, uniqueName)
  },
})

// Filtres pour valider les fichiers
const fileFilter = (
  req: Request,
  file: Express.Multer.File,
  callback: multer.FileFilterCallback
) => {
  const allowedImageTypes = [
    "image/jpeg",
    "image/png",
    "image/gif",
    "image/webp",
  ]
  const allowedVideoTypes = [
    "video/mp4",
    "video/mpeg",
    "video/quicktime", // .mov
  ]

  if (
    allowedImageTypes.includes(file.mimetype) ||
    allowedVideoTypes.includes(file.mimetype)
  ) {
    callback(null, true)
  } else {
    callback(
      new Error(
        `Type de fichier non autorisé: ${file.mimetype}. ` +
          `Images acceptées: JPEG, PNG, GIF, WebP. ` +
          `Vidéos acceptées: MP4, MPEG, MOV.`
      )
    )
  }
}

// Configuration principale de Multer
export const upload = multer({
  storage: storage,
  fileFilter: fileFilter,
  limits: {
    fileSize: 100 * 1024 * 1024, // 100MB max
    files: 15, // Maximum 15 fichiers au total
  },
})

// Middlewares d'upload
export const uploadImage = upload.single("image")
export const uploadVideo = upload.single("video")
export const uploadMultiple = upload.fields([
  { name: "images", maxCount: 10 },
  { name: "videos", maxCount: 5 },
])

// Middleware de gestion d'erreurs Multer
export const handleMulterError = (
  err: any,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (err instanceof multer.MulterError) {
    switch (err.code) {
      case "LIMIT_FILE_SIZE":
        return res.status(400).json({
          error: "Fichier trop volumineux (maximum 100MB)",
        })
      case "LIMIT_FILE_COUNT":
        return res.status(400).json({
          error: "Trop de fichiers uploadés",
        })
      case "LIMIT_UNEXPECTED_FILE":
        return res.status(400).json({
          error: "Champ de fichier inattendu",
          field: err.field,
        })
      default:
        return res.status(400).json({
          error: `Erreur d'upload: ${err.message}`,
        })
    }
  }

  if (err) {
    return res.status(400).json({
      error: err.message,
    })
  }

  next()
}
