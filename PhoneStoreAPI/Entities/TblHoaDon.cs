namespace PhoneStoreAPI.Entities;

public partial class TblHoaDon
{
    public int MaHd { get; set; }

    public DateTime NgayLap { get; set; }

    public string? TenKhachHang { get; set; }

    public decimal TongTien { get; set; }

    public virtual ICollection<TblChiTietHoaDon> TblChiTietHoaDons { get; set; } = new List<TblChiTietHoaDon>();
}
