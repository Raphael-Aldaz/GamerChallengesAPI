import { Media } from "@prisma/client"
import BaseController from "../BaseController.js"
import { prisma } from "../../../prisma/index.js"
import { Request, Response } from "express"
import path from "node:path"
import { fileURLToPath } from "node:url"

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

export class MediaController extends BaseController<Media, "media_id"> {
  constructor() {
    super(prisma.media, "media_id")
  }

  async getMedia(req: Request, res: Response) {
    const filePath = path.join(__dirname, "../../../uploads")
    return res.json({ filePath })
  }
}
