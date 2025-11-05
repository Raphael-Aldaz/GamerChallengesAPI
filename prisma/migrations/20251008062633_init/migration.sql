-- CreateTable
CREATE TABLE "User" (
    "user_id" SERIAL NOT NULL,
    "pseudo" TEXT NOT NULL,

    CONSTRAINT "User_pkey" PRIMARY KEY ("user_id")
);

-- CreateIndex
CREATE UNIQUE INDEX "User_pseudo_key" ON "User"("pseudo");
