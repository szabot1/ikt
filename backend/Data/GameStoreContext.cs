using Microsoft.EntityFrameworkCore;
using backend.Models;

namespace backend.Data;

public partial class GameStoreContext : DbContext
{
    public GameStoreContext(DbContextOptions<GameStoreContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Game> Games { get; set; } = null!;

    public virtual DbSet<GameImage> GameImages { get; set; } = null!;

    public virtual DbSet<GameTag> GameTags { get; set; } = null!;

    public virtual DbSet<Offer> Offers { get; set; } = null!;

    public virtual DbSet<OfferType> OfferTypes { get; set; } = null!;

    public virtual DbSet<Order> Orders { get; set; } = null!;

    public virtual DbSet<Seller> Sellers { get; set; } = null!;

    public virtual DbSet<Tag> Tags { get; set; } = null!;

    public virtual DbSet<User> Users { get; set; } = null!;

    public virtual DbSet<UserExperience> UserExperiences { get; set; } = null!;

    public virtual DbSet<UserRefreshToken> UserRefreshTokens { get; set; } = null!;

    public virtual DbSet<UserSocial> UserSocials { get; set; } = null!;

    public virtual DbSet<EmailToken> EmailTokens { get; set; } = null!;

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .HasPostgresEnum("order_status", new[] { "validating", "payment_pending", "payment_failed", "payment_succeeded", "fulfilled", "refunded", "cancelled" })
            .HasPostgresEnum("user_role", new[] { "user", "support", "admin" });

        modelBuilder.Entity<Game>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("games_pkey");

            entity.ToTable("games");

            entity.HasIndex(e => e.Name, "games_name_idx");

            entity.HasIndex(e => e.Slug, "games_slug_idx");

            entity.HasIndex(e => e.Slug, "games_slug_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.IsActive)
                .IsRequired()
                .HasDefaultValueSql("true")
                .HasColumnName("is_active");
            entity.Property(e => e.IsFeatured).HasColumnName("is_featured");
            entity.Property(e => e.Name).HasColumnName("name");
            entity.Property(e => e.Slug).HasColumnName("slug");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("updated_at");
        });

        modelBuilder.Entity<GameImage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("game_images_pkey");

            entity.ToTable("game_images");

            entity.HasIndex(e => e.GameId, "game_images_game_id_idx");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.GameId).HasColumnName("game_id");
            entity.Property(e => e.ImageUrl).HasColumnName("image_url");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Game).WithMany(p => p.GameImages)
                .HasForeignKey(d => d.GameId)
                .HasConstraintName("game_images_game_id_fkey");
        });

        modelBuilder.Entity<GameTag>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("game_tags_pkey");

            entity.ToTable("game_tags");

            entity.HasIndex(e => e.GameId, "game_tags_game_id_idx");

            entity.HasIndex(e => e.TagId, "game_tags_tag_id_idx");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.GameId).HasColumnName("game_id");
            entity.Property(e => e.TagId).HasColumnName("tag_id");

            entity.HasOne(d => d.Game).WithMany(p => p.GameTags)
                .HasForeignKey(d => d.GameId)
                .HasConstraintName("game_tags_game_id_fkey");

            entity.HasOne(d => d.Tag).WithMany(p => p.GameTags)
                .HasForeignKey(d => d.TagId)
                .HasConstraintName("game_tags_tag_id_fkey");
        });

        modelBuilder.Entity<Offer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("offers_pkey");

            entity.ToTable("offers");

            entity.HasIndex(e => e.GameId, "offers_game_id_idx");

            entity.HasIndex(e => e.Price, "offers_price_idx");

            entity.HasIndex(e => e.SellerId, "offers_seller_id_idx");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.GameId).HasColumnName("game_id");
            entity.Property(e => e.IsActive)
                .IsRequired()
                .HasDefaultValueSql("true")
                .HasColumnName("is_active");
            entity.Property(e => e.Price).HasColumnName("price");
            entity.Property(e => e.SellerId).HasColumnName("seller_id");
            entity.Property(e => e.Type).HasColumnName("type");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.Game).WithMany(p => p.Offers)
                .HasForeignKey(d => d.GameId)
                .HasConstraintName("offers_game_id_fkey");

            entity.HasOne(d => d.Seller).WithMany(p => p.Offers)
                .HasForeignKey(d => d.SellerId)
                .HasConstraintName("offers_seller_id_fkey");

            entity.HasOne(d => d.TypeNavigation).WithMany(p => p.Offers)
                .HasForeignKey(d => d.Type)
                .HasConstraintName("offers_type_fkey");
        });

        modelBuilder.Entity<OfferType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("offer_types_pkey");

            entity.ToTable("offer_types");

            entity.HasIndex(e => e.Id, "offer_types_id_idx");

            entity.HasIndex(e => e.Name, "offer_types_name_idx");

            entity.HasIndex(e => e.Name, "offer_types_name_key").IsUnique();

            entity.HasIndex(e => e.Slug, "offer_types_slug_idx");

            entity.HasIndex(e => e.Slug, "offer_types_slug_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.ClaimInstructions).HasColumnName("claim_instructions");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.Description).HasColumnName("description");
            entity.Property(e => e.Name).HasColumnName("name");
            entity.Property(e => e.Slug).HasColumnName("slug");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("orders_pkey");

            entity.ToTable("orders");

            entity.HasIndex(e => e.GameId, "orders_game_id_idx");

            entity.HasIndex(e => e.StripePaymentIntentId, "orders_stripe_payment_intent_id_idx");

            entity.HasIndex(e => e.UserId, "orders_user_id_idx");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.GameId).HasColumnName("game_id");
            entity.Property(e => e.OfferId).HasColumnName("offer_id");
            entity.Property(e => e.StripePaymentIntentId).HasColumnName("stripe_payment_intent_id");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.Game).WithMany(p => p.Orders)
                .HasForeignKey(d => d.GameId)
                .HasConstraintName("orders_game_id_fkey");

            entity.HasOne(d => d.Offer).WithMany(p => p.Orders)
                .HasForeignKey(d => d.OfferId)
                .HasConstraintName("orders_offer_id_fkey");

            entity.HasOne(d => d.User).WithMany(p => p.Orders)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("orders_user_id_fkey");
        });

        modelBuilder.Entity<Seller>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("sellers_pkey");

            entity.ToTable("sellers");

            entity.HasIndex(e => e.DisplayName, "sellers_display_name_idx");

            entity.HasIndex(e => e.Slug, "sellers_slug_idx");

            entity.HasIndex(e => e.Slug, "sellers_slug_key").IsUnique();

            entity.HasIndex(e => e.UserId, "sellers_user_id_idx");

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.DisplayName).HasColumnName("display_name");
            entity.Property(e => e.ImageUrl).HasColumnName("image_url");
            entity.Property(e => e.IsVerified).HasColumnName("is_verified");
            entity.Property(e => e.IsClosed).HasColumnName("is_closed");
            entity.Property(e => e.Slug).HasColumnName("slug");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("updated_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithOne(p => p.Seller)
                .HasForeignKey<Seller>(d => d.UserId)
                .HasConstraintName("sellers_user_id_fkey");
        });

        modelBuilder.Entity<Tag>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("tags_pkey");

            entity.ToTable("tags");

            entity.HasIndex(e => e.Name, "tags_name_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.Name).HasColumnName("name");
        });

        modelBuilder.HasPostgresEnum<UserRole>();

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("users_pkey");

            entity.ToTable("users");

            entity.HasIndex(e => e.Email, "users_email_idx");

            entity.HasIndex(e => e.Email, "users_email_key").IsUnique();

            entity.HasIndex(e => e.StripeCustomerId, "users_stripe_customer_id_idx");

            entity.HasIndex(e => e.Username, "users_username_idx");

            entity.HasIndex(e => e.Username, "users_username_key").IsUnique();

            entity.Property(e => e.Id).HasColumnName("id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.Email).HasColumnName("email");
            entity.Property(e => e.Password).HasColumnName("password");
            entity.Property(e => e.Role).HasColumnName("role");
            entity.Property(e => e.StripeCustomerId).HasColumnName("stripe_customer_id");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("updated_at");
            entity.Property(e => e.Username).HasColumnName("username");
        });

        modelBuilder.Entity<UserExperience>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("user_experience_pkey");

            entity.ToTable("user_experience");

            entity.HasIndex(e => e.UserId, "user_experience_user_id_idx");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.Experience).HasColumnName("experience");

            entity.HasOne(d => d.User).WithOne(p => p.UserExperience)
                .HasForeignKey<UserExperience>(d => d.UserId)
                .HasConstraintName("user_experience_user_id_fkey");
        });

        modelBuilder.Entity<UserRefreshToken>(entity =>
        {
            entity.HasKey(e => e.Token).HasName("user_refresh_tokens_pkey");

            entity.ToTable("user_refresh_tokens");

            entity.HasIndex(e => e.UserId, "user_refresh_tokens_user_id_idx");

            entity.Property(e => e.Token).HasColumnName("token");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.UserId).HasColumnName("user_id");

            entity.HasOne(d => d.User).WithMany(p => p.UserRefreshTokens)
                .HasForeignKey(d => d.UserId)
                .HasConstraintName("user_refresh_tokens_user_id_fkey");
        });

        modelBuilder.Entity<UserSocial>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("user_social_pkey");

            entity.ToTable("user_social");

            entity.HasIndex(e => e.UserId, "user_social_user_id_idx");

            entity.Property(e => e.UserId).HasColumnName("user_id");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
            entity.Property(e => e.Discord).HasColumnName("discord");
            entity.Property(e => e.Epic).HasColumnName("epic");
            entity.Property(e => e.Origin).HasColumnName("origin");
            entity.Property(e => e.Steam).HasColumnName("steam");
            entity.Property(e => e.Ubisoft).HasColumnName("ubisoft");
            entity.Property(e => e.UpdatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("updated_at");

            entity.HasOne(d => d.User).WithOne(p => p.UserSocial)
                .HasForeignKey<UserSocial>(d => d.UserId)
                .HasConstraintName("user_social_user_id_fkey");
        });

        modelBuilder.Entity<EmailToken>(entity =>
        {
            entity.HasKey(e => e.Email).HasName("email_tokens_pkey");

            entity.ToTable("email_tokens");

            entity.HasIndex(e => e.Token, "email_tokens_token_idx");

            entity.Property(e => e.Email).HasColumnName("email");
            entity.Property(e => e.Token).HasColumnName("token");
            entity.Property(e => e.CreatedAt)
                .HasDefaultValueSql("CURRENT_TIMESTAMP")
                .HasColumnType("timestamp without time zone")
                .HasColumnName("created_at");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
