using Microsoft.EntityFrameworkCore;

namespace PhoneStoreAPI.Entities;

// Tương đương kết quả lệnh:
// Scaffold-DbContext "<chuỗi kết nối>" Microsoft.EntityFrameworkCore.SqlServer -OutputDir Entities -Context PhoneStoreContext -NoOnConfiguring
public partial class PhoneStoreContext : DbContext
{
    public PhoneStoreContext()
    {
    }

    public PhoneStoreContext(DbContextOptions<PhoneStoreContext> options)
        : base(options)
    {
    }

    public virtual DbSet<TblDienThoai> TblDienThoais { get; set; }

    public virtual DbSet<TblHoaDon> TblHoaDons { get; set; }

    public virtual DbSet<TblChiTietHoaDon> TblChiTietHoaDons { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<TblDienThoai>(entity =>
        {
            entity.HasKey(e => e.MaDt);
            entity.ToTable("tblDienThoai");

            entity.Property(e => e.MaDt).HasMaxLength(10).HasColumnName("MaDT");
            entity.Property(e => e.TenDt).HasMaxLength(100).HasColumnName("TenDT");
            entity.Property(e => e.MoTa).HasMaxLength(500);
            entity.Property(e => e.Gia).HasColumnType("decimal(18, 0)");
            entity.Property(e => e.HinhAnh).HasMaxLength(255);
        });

        modelBuilder.Entity<TblHoaDon>(entity =>
        {
            entity.HasKey(e => e.MaHd);
            entity.ToTable("tblHoaDon");

            entity.Property(e => e.MaHd).HasColumnName("MaHD");
            entity.Property(e => e.NgayLap).HasColumnType("datetime").HasDefaultValueSql("(getdate())");
            entity.Property(e => e.TenKhachHang).HasMaxLength(100);
            entity.Property(e => e.TongTien).HasColumnType("decimal(18, 0)");
        });

        modelBuilder.Entity<TblChiTietHoaDon>(entity =>
        {
            entity.HasKey(e => new { e.MaHd, e.MaDt });
            entity.ToTable("tblChiTietHoaDon");

            entity.Property(e => e.MaHd).HasColumnName("MaHD");
            entity.Property(e => e.MaDt).HasMaxLength(10).HasColumnName("MaDT");
            entity.Property(e => e.DonGia).HasColumnType("decimal(18, 0)");

            entity.HasOne(d => d.MaDtNavigation).WithMany(p => p.TblChiTietHoaDons)
                .HasForeignKey(d => d.MaDt)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK_tblChiTietHoaDon_tblDienThoai");

            entity.HasOne(d => d.MaHdNavigation).WithMany(p => p.TblChiTietHoaDons)
                .HasForeignKey(d => d.MaHd)
                .OnDelete(DeleteBehavior.Cascade)
                .HasConstraintName("FK_tblChiTietHoaDon_tblHoaDon");
        });

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
