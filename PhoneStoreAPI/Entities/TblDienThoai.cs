namespace PhoneStoreAPI.Entities;

public partial class TblDienThoai
{
    public string MaDt { get; set; } = null!;

    public string TenDt { get; set; } = null!;

    public string? MoTa { get; set; }

    public decimal Gia { get; set; }

    public string? HinhAnh { get; set; }

    public virtual ICollection<TblChiTietHoaDon> TblChiTietHoaDons { get; set; } = new List<TblChiTietHoaDon>();
}
