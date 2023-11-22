using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace backend.Models;

[Table("user_experience")]
[Index("UserId", Name = "user_experience_user_id_idx")]
public partial class UserExperience
{
    [Key]
    [Column("user_id")]
    public string UserId { get; set; } = null!;

    [Column("experience")]
    public int Experience { get; set; }

    [ForeignKey("UserId")]
    [InverseProperty("UserExperience")]
    public virtual User User { get; set; } = null!;
}
