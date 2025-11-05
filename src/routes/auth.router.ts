import { Router } from "express"
import { getAuthenticatedUser, login, logout } from "../controllers/AuthController/AuthController.js"
import { verifyToken } from "../../middlewares/auth.middleware.js"

const router = Router()
router.post("/login", login)
router.post("/logout", logout)
router.get("/me", verifyToken, getAuthenticatedUser)
//TODO
// router.post("/register", (req, res) => authController.register(req, res))
// router.patch("/delete/:userId", verifyToken({ validityRequired: true }), (req, res) =>
//   authController.softDeleteUser(req, res)
// )
export default router
