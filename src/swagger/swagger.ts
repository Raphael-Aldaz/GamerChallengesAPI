// src/swagger/swagger.js
import swaggerJSDoc from "swagger-jsdoc"

const options = {
  definition: {
    openapi: "3.0.0",
    info: {
      title: "API GamerChallenge - Documentation Swagger",
      version: "1.0.0",
      description: "Documentation générée automatiquement avec Swagger",
    },
    servers: [
      {
        url: "http://localhost:5000/api",
        description: "Serveur local",
      },
    ],
  },

  // 🧭 chemins corrigés
  apis: ["./src/routes/*.ts", "./src/swagger/schemas.yaml"],
}

const swaggerSpec = swaggerJSDoc(options)
export default swaggerSpec
