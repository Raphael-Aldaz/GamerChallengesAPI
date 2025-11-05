import express from "express"
import cors from "cors"
import { config } from "../config.js"
import { xssSanitizer } from "../middlewares/xss/xss-sanitizer.middleware.js"
import { helmetMiddleware } from "../middlewares/helmet/helmet.middleware.js"
import { loggerMiddleware } from "../middlewares/logger.middleware.js"
import { infoMiddleware } from "../middlewares/info.middleware.js"
import { globalErrorMiddleware } from "../middlewares/globalError.middleware.js"
import { router } from "./router.js"
import swaggerUi from "swagger-ui-express"
import swaggerSpec from "./swagger/swagger.js"
import cookieParser from "cookie-parser"
export const app = express()

app.use(cors({ origin: config.server.allowedOrigins }))
app.use(cookieParser())
app.use(express.json())
app.disable("x-powered-by")
app.use(xssSanitizer)
app.use(helmetMiddleware)
app.use(loggerMiddleware)
app.get("/info", infoMiddleware)
app.use("/api/docs", swaggerUi.serve)
app.get("/api/docs", swaggerUi.setup(swaggerSpec))
app.use("/api", router)
app.use(globalErrorMiddleware)
