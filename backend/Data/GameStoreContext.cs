using Microsoft.EntityFrameworkCore;
using backend.Models;

namespace backend.Data;

public partial class GameStoreContext : DbContext
{
    public GameStoreContext()
    {
    }

    public GameStoreContext(DbContextOptions<GameStoreContext> options)
        : base(options)
    {
    }

    public virtual DbSet<Game> Games { get; set; }

    public virtual DbSet<GameImage> GameImages { get; set; }

    public virtual DbSet<GameTag> GameTags { get; set; }

    public virtual DbSet<Offer> Offers { get; set; }

    public virtual DbSet<OfferType> OfferTypes { get; set; }

    public virtual DbSet<Order> Orders { get; set; }

    public virtual DbSet<Seller> Sellers { get; set; }

    public virtual DbSet<Tag> Tags { get; set; }

    public virtual DbSet<User> Users { get; set; }

    public virtual DbSet<UserRefreshToken> UserRefreshTokens { get; set; }

    public virtual DbSet<UserExperience> UserExperiences { get; set; }

    public virtual DbSet<UserSocial> UserSocials { get; set; }
    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder
            .HasPostgresEnum("order_status", new[] { "validating", "payment_pending", "payment_failed", "payment_succeeded", "fulfilled", "refunded", "cancelled" })
            .HasPostgresEnum("user_role", new[] { "user", "support", "admin" });

        modelBuilder.Entity<Game>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("games_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.IsActive).HasDefaultValueSql("true");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<GameImage>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("game_images_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Game).WithMany(p => p.GameImages).HasConstraintName("game_images_game_id_fkey");
        });

        modelBuilder.Entity<GameTag>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("game_tags_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Game).WithMany(p => p.GameTags).HasConstraintName("game_tags_game_id_fkey");

            entity.HasOne(d => d.Tag).WithMany(p => p.GameTags).HasConstraintName("game_tags_tag_id_fkey");
        });

        modelBuilder.Entity<Offer>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("offers_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.IsActive).HasDefaultValueSql("true");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Game).WithMany(p => p.Offers).HasConstraintName("offers_game_id_fkey");

            entity.HasOne(d => d.Seller).WithMany(p => p.Offers).HasConstraintName("offers_seller_id_fkey");

            entity.HasOne(d => d.TypeNavigation).WithMany(p => p.Offers).HasConstraintName("offers_type_fkey");
        });

        modelBuilder.Entity<OfferType>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("offer_types_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<Order>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("orders_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.Game).WithMany(p => p.Orders).HasConstraintName("orders_game_id_fkey");

            entity.HasOne(d => d.Offer).WithMany(p => p.Orders).HasConstraintName("orders_offer_id_fkey");

            entity.HasOne(d => d.User).WithMany(p => p.Orders).HasConstraintName("orders_user_id_fkey");
        });

        modelBuilder.Entity<Seller>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("sellers_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.User).WithMany(p => p.Sellers).HasConstraintName("sellers_user_id_fkey");
        });

        modelBuilder.Entity<Tag>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("tags_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<User>(entity =>
        {
            entity.HasKey(e => e.Id).HasName("users_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
        });

        modelBuilder.Entity<UserRefreshToken>(entity =>
        {
            entity.HasKey(e => e.Token).HasName("user_refresh_tokens_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.User).WithMany(p => p.UserRefreshTokens).HasConstraintName("user_refresh_tokens_user_id_fkey");
        });

        modelBuilder.Entity<UserExperience>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("user_experience_pkey");

            entity.HasOne(d => d.User).WithOne(p => p.UserExperience).HasConstraintName("user_experience_user_id_fkey");
        });

        modelBuilder.Entity<UserSocial>(entity =>
        {
            entity.HasKey(e => e.UserId).HasName("user_social_pkey");

            entity.Property(e => e.CreatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");
            entity.Property(e => e.UpdatedAt).HasDefaultValueSql("CURRENT_TIMESTAMP");

            entity.HasOne(d => d.User).WithOne(p => p.UserSocial).HasConstraintName("user_social_user_id_fkey");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
