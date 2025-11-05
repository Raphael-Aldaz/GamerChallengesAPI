import { Router } from "express"
import * as challengeController from "../controllers/ChallengeController/ChallengeController.js"
import { controllerWrapper as cw } from "../../utils/controllerWrapper.js"
const router = Router()
/**
 * @swagger
 * /challenges/newest:
 *   get:
 *     summary: Get the 4 last created challenges
 *     tags: [Challenges]
 *     responses:
 *       200:
 *         description: Successfully retrieved the 4 newest challenges
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Challenge'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Failed to retrieve challenges"
 */
router.get("/newest", cw(challengeController.getNewestChallenges))
/**
 * @swagger
 * /challenges/popular:
 *   get:
 *     summary: Get the 5 most liked challenges
 *     tags: [Challenges]
 *     responses:
 *       200:
 *         description: Successfully retrieved the 5 most likes challenges
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Challenge'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Failed to retrieve challenges"
 */
router.get("/popular", cw(challengeController.getMostPopulareChallenges))
/**
 * @swagger
 * /challenges:
 *   get:
 *     summary: Get the challenges by game id
 *     tags: [Challenges]
 *     parameters:
 *       - in: query
 *         name: gameId
 *         schema:
 *           type: integer
 *         required: false
 *         description: ID of the game to filter challenges
 *     responses:
 *       200:
 *         description: Successfully retrieved the challenges by the game id
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Challenge'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Failed to retrieve challenges"
 */

router.get("/", cw(challengeController.getChallengesByGameId))
/**
 * @swagger
 * /challenges/featuredChallenges:
 *   get:
 *     summary: Get 5 featured challenges
 *     tags: [Challenges]
 *     responses:
 *       200:
 *         description: Successfully retrieved  5 featured challenges
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Challenge'
 *       500:
 *         description: Internal server error
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 error:
 *                   type: string
 *                   example: "Failed to retrieve challenges"
 */

router.get("/featuredChallenges", cw(challengeController.getFeaturedChallenges))

export default router
