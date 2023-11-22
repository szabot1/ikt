using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("offer_types")]
[Index("Id", Name = "offer_types_id_idx")]
[Index("Name", Name = "offer_types_name_idx")]
[Index("Name", Name = "offer_types_name_key", IsUnique = true)]
[Index("Slug", Name = "offer_types_slug_idx")]
[Index("Slug", Name = "offer_types_slug_key", IsUnique = true)]
public partial class OfferType
{
    [Key]
    [Column("id")]
    public string Id { get; set; } = null!;

    [Column("slug")]
    public string Slug { get; set; } = null!;

    [Column("name")]
    public string Name { get; set; } = null!;

    [Column("description")]
    public string Description { get; set; } = null!;

    [Column("claim_instructions")]
    public string ClaimInstructions { get; set; } = null!;

    [Column("created_at", TypeName = "timestamp without time zone")]
    public DateTime CreatedAt { get; set; }

    [InverseProperty("TypeNavigation")]
    public virtual ICollection<Offer> Offers { get; set; } = new List<Offer>();
}
