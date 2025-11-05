/*
  Warnings:

  - You are about to drop the column `issued_at` on the `refresh_token` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "refresh_token" DROP COLUMN "issued_at",
ADD COLUMN     "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;
