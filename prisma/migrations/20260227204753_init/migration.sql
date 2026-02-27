-- CreateEnum
CREATE TYPE "UserRole" AS ENUM ('USER', 'ADMIN');

-- CreateEnum
CREATE TYPE "SubscriptionTier" AS ENUM ('FREE', 'MONTHLY', 'YEARLY', 'LIFETIME');

-- CreateEnum
CREATE TYPE "SubscriptionStatus" AS ENUM ('ACTIVE', 'INACTIVE', 'EXPIRED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "PlanType" AS ENUM ('MONTHLY', 'YEARLY', 'LIFETIME');

-- CreateEnum
CREATE TYPE "PaymentStatus" AS ENUM ('PENDING', 'SUCCEEDED', 'FAILED', 'REFUNDED');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED', 'CANCELLED');

-- CreateTable
CREATE TABLE "users" (
    "id" UUID NOT NULL,
    "email" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "role" "UserRole" NOT NULL DEFAULT 'USER',
    "subscription_tier" "SubscriptionTier" NOT NULL DEFAULT 'FREE',
    "subscription_status" "SubscriptionStatus" NOT NULL DEFAULT 'INACTIVE',
    "subscription_start_date" TIMESTAMP(3),
    "subscription_end_date" TIMESTAMP(3),
    "stripe_customer_id" TEXT,
    "stripe_subscription_id" TEXT,
    "audio_listen_time" INTEGER NOT NULL DEFAULT 0,
    "email_verified" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "categories" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "books" (
    "id" SERIAL NOT NULL,
    "title" TEXT NOT NULL,
    "slug" TEXT NOT NULL,
    "author" TEXT NOT NULL,
    "category_id" INTEGER NOT NULL,
    "description" TEXT,
    "cover_image_url" TEXT,
    "original_pdf_url" TEXT,
    "original_pdf_path" TEXT,
    "publication_year" INTEGER,
    "isbn" TEXT,
    "reading_time_minutes" INTEGER NOT NULL DEFAULT 15,
    "total_audio_duration" INTEGER NOT NULL DEFAULT 0,
    "average_rating" DECIMAL(3,2) NOT NULL DEFAULT 0,
    "total_reviews" INTEGER NOT NULL DEFAULT 0,
    "view_count" INTEGER NOT NULL DEFAULT 0,
    "is_featured" BOOLEAN NOT NULL DEFAULT false,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "is_summary_generated" BOOLEAN NOT NULL DEFAULT false,
    "is_audio_generated" BOOLEAN NOT NULL DEFAULT false,
    "created_by" UUID NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "books_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "book_summaries" (
    "id" SERIAL NOT NULL,
    "book_id" INTEGER NOT NULL,
    "main_summary" TEXT,
    "key_takeaways" JSONB,
    "full_summary" TEXT,
    "table_of_contents" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "book_summaries_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "book_chapters" (
    "id" SERIAL NOT NULL,
    "book_id" INTEGER NOT NULL,
    "chapter_number" INTEGER NOT NULL,
    "chapter_title" TEXT NOT NULL,
    "chapter_summary" TEXT NOT NULL,
    "audio_url" TEXT,
    "audio_duration" INTEGER NOT NULL DEFAULT 0,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "book_chapters_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "book_reviews" (
    "id" SERIAL NOT NULL,
    "book_id" INTEGER NOT NULL,
    "user_id" UUID NOT NULL,
    "rating" INTEGER NOT NULL,
    "review_title" TEXT,
    "review_text" TEXT,
    "is_purchase_verified" BOOLEAN NOT NULL DEFAULT false,
    "is_approved" BOOLEAN NOT NULL DEFAULT true,
    "helpful_count" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "book_reviews_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_favorites" (
    "id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "book_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_favorites_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_reading_history" (
    "id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "book_id" INTEGER NOT NULL,
    "last_accessed" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "completion_percentage" INTEGER NOT NULL DEFAULT 0,
    "audio_position" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_reading_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_plans" (
    "id" SERIAL NOT NULL,
    "plan_name" TEXT NOT NULL,
    "plan_type" "PlanType" NOT NULL,
    "price" DECIMAL(10,2) NOT NULL,
    "features" JSONB,
    "stripe_price_id" TEXT,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "display_order" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subscription_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "payment_transactions" (
    "id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "stripe_payment_intent_id" TEXT,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "payment_status" "PaymentStatus" NOT NULL,
    "plan_type" "PlanType" NOT NULL,
    "metadata" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payment_transactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_orders" (
    "id" SERIAL NOT NULL,
    "user_id" UUID NOT NULL,
    "plan_type" "PlanType" NOT NULL,
    "amount" DECIMAL(10,2) NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "payment_method" TEXT NOT NULL DEFAULT 'BANK_TRANSFER',
    "payment_proof_url" TEXT,
    "transaction_reference" TEXT,
    "order_status" "OrderStatus" NOT NULL DEFAULT 'PENDING',
    "approved_by" TEXT,
    "approved_at" TIMESTAMP(3),
    "rejected_reason" TEXT,
    "notes" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "subscription_orders_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "admin_activity_logs" (
    "id" SERIAL NOT NULL,
    "admin_id" UUID NOT NULL,
    "action_type" TEXT NOT NULL,
    "target_type" TEXT NOT NULL,
    "target_id" INTEGER,
    "description" TEXT,
    "ip_address" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_activity_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "categories_name_key" ON "categories"("name");

-- CreateIndex
CREATE UNIQUE INDEX "categories_slug_key" ON "categories"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "books_slug_key" ON "books"("slug");

-- CreateIndex
CREATE INDEX "books_is_published_category_id_idx" ON "books"("is_published", "category_id");

-- CreateIndex
CREATE INDEX "books_is_published_is_featured_idx" ON "books"("is_published", "is_featured");

-- CreateIndex
CREATE INDEX "books_category_id_idx" ON "books"("category_id");

-- CreateIndex
CREATE INDEX "books_created_by_idx" ON "books"("created_by");

-- CreateIndex
CREATE INDEX "books_slug_idx" ON "books"("slug");

-- CreateIndex
CREATE UNIQUE INDEX "book_summaries_book_id_key" ON "book_summaries"("book_id");

-- CreateIndex
CREATE INDEX "book_chapters_book_id_chapter_number_idx" ON "book_chapters"("book_id", "chapter_number");

-- CreateIndex
CREATE INDEX "book_reviews_book_id_created_at_idx" ON "book_reviews"("book_id", "created_at");

-- CreateIndex
CREATE INDEX "book_reviews_user_id_idx" ON "book_reviews"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "book_reviews_book_id_user_id_key" ON "book_reviews"("book_id", "user_id");

-- CreateIndex
CREATE INDEX "user_favorites_book_id_idx" ON "user_favorites"("book_id");

-- CreateIndex
CREATE INDEX "user_favorites_user_id_idx" ON "user_favorites"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_favorites_book_id_user_id_key" ON "user_favorites"("book_id", "user_id");

-- CreateIndex
CREATE INDEX "user_reading_history_user_id_last_accessed_idx" ON "user_reading_history"("user_id", "last_accessed");

-- CreateIndex
CREATE INDEX "user_reading_history_book_id_idx" ON "user_reading_history"("book_id");

-- CreateIndex
CREATE INDEX "user_reading_history_user_id_idx" ON "user_reading_history"("user_id");

-- CreateIndex
CREATE UNIQUE INDEX "user_reading_history_book_id_user_id_key" ON "user_reading_history"("book_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "subscription_plans_plan_name_key" ON "subscription_plans"("plan_name");

-- CreateIndex
CREATE UNIQUE INDEX "payment_transactions_stripe_payment_intent_id_key" ON "payment_transactions"("stripe_payment_intent_id");

-- CreateIndex
CREATE INDEX "payment_transactions_user_id_idx" ON "payment_transactions"("user_id");

-- CreateIndex
CREATE INDEX "subscription_orders_user_id_idx" ON "subscription_orders"("user_id");

-- CreateIndex
CREATE INDEX "subscription_orders_order_status_idx" ON "subscription_orders"("order_status");

-- CreateIndex
CREATE INDEX "admin_activity_logs_target_type_target_id_idx" ON "admin_activity_logs"("target_type", "target_id");

-- CreateIndex
CREATE INDEX "admin_activity_logs_admin_id_idx" ON "admin_activity_logs"("admin_id");

-- AddForeignKey
ALTER TABLE "books" ADD CONSTRAINT "books_category_id_fkey" FOREIGN KEY ("category_id") REFERENCES "categories"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "books" ADD CONSTRAINT "books_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_summaries" ADD CONSTRAINT "book_summaries_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_chapters" ADD CONSTRAINT "book_chapters_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_reviews" ADD CONSTRAINT "book_reviews_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "book_reviews" ADD CONSTRAINT "book_reviews_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_favorites" ADD CONSTRAINT "user_favorites_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_favorites" ADD CONSTRAINT "user_favorites_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_reading_history" ADD CONSTRAINT "user_reading_history_book_id_fkey" FOREIGN KEY ("book_id") REFERENCES "books"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_reading_history" ADD CONSTRAINT "user_reading_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "payment_transactions" ADD CONSTRAINT "payment_transactions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "subscription_orders" ADD CONSTRAINT "subscription_orders_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "admin_activity_logs" ADD CONSTRAINT "admin_activity_logs_admin_id_fkey" FOREIGN KEY ("admin_id") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
