/*
  Warnings:

  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "public"."User";

-- CreateTable
CREATE TABLE "role" (
    "role_id" SERIAL NOT NULL,
    "role_name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "role_pkey" PRIMARY KEY ("role_id")
);

-- CreateTable
CREATE TABLE "user" (
    "user_id" SERIAL NOT NULL,
    "pseudo" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "avatar" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_pkey" PRIMARY KEY ("user_id")
);

-- CreateTable
CREATE TABLE "UserRole" (
    "user_id" INTEGER NOT NULL,
    "role_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "UserRole_pkey" PRIMARY KEY ("user_id","role_id")
);

-- CreateTable
CREATE TABLE "game" (
    "game_id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "game_image" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "game_pkey" PRIMARY KEY ("game_id")
);

-- CreateTable
CREATE TABLE "particiation" (
    "participation_id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "participation_video" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "challenge_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "particiation_pkey" PRIMARY KEY ("participation_id")
);

-- CreateTable
CREATE TABLE "challenge" (
    "challenge_id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "desciption" TEXT NOT NULL,
    "rules" TEXT NOT NULL,
    "user_id" INTEGER NOT NULL,
    "game_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "deleted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "challenge_pkey" PRIMARY KEY ("challenge_id")
);

-- CreateTable
CREATE TABLE "ChallengeLike" (
    "user_id" INTEGER NOT NULL,
    "challenge_id" INTEGER NOT NULL,

    CONSTRAINT "ChallengeLike_pkey" PRIMARY KEY ("user_id","challenge_id")
);

-- CreateTable
CREATE TABLE "ParticipationLike" (
    "user_id" INTEGER NOT NULL,
    "participation_id" INTEGER NOT NULL,

    CONSTRAINT "ParticipationLike_pkey" PRIMARY KEY ("user_id","participation_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "role_role_name_key" ON "role"("role_name");

-- CreateIndex
CREATE UNIQUE INDEX "user_pseudo_key" ON "user"("pseudo");

-- CreateIndex
CREATE UNIQUE INDEX "user_email_key" ON "user"("email");

-- CreateIndex
CREATE UNIQUE INDEX "game_title_key" ON "game"("title");

-- CreateIndex
CREATE INDEX "ChallengeLike_challenge_id_idx" ON "ChallengeLike"("challenge_id");

-- CreateIndex
CREATE INDEX "ChallengeLike_user_id_idx" ON "ChallengeLike"("user_id");

-- CreateIndex
CREATE INDEX "ParticipationLike_participation_id_idx" ON "ParticipationLike"("participation_id");

-- CreateIndex
CREATE INDEX "ParticipationLike_user_id_idx" ON "ParticipationLike"("user_id");

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "UserRole" ADD CONSTRAINT "UserRole_role_id_fkey" FOREIGN KEY ("role_id") REFERENCES "role"("role_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "particiation" ADD CONSTRAINT "particiation_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "particiation" ADD CONSTRAINT "particiation_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenge"("challenge_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge" ADD CONSTRAINT "challenge_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "challenge" ADD CONSTRAINT "challenge_game_id_fkey" FOREIGN KEY ("game_id") REFERENCES "game"("game_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChallengeLike" ADD CONSTRAINT "ChallengeLike_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ChallengeLike" ADD CONSTRAINT "ChallengeLike_challenge_id_fkey" FOREIGN KEY ("challenge_id") REFERENCES "challenge"("challenge_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipationLike" ADD CONSTRAINT "ParticipationLike_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "user"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ParticipationLike" ADD CONSTRAINT "ParticipationLike_participation_id_fkey" FOREIGN KEY ("participation_id") REFERENCES "particiation"("participation_id") ON DELETE RESTRICT ON UPDATE CASCADE;
