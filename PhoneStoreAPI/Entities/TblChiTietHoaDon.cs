namespace PhoneStoreAPI.Entities;

public partial class TblChiTietHoaDon
{
    public int MaHd { get; set; }

    public string MaDt { get; set; } = null!;

    public int SoLuong { get; set; }

    public decimal DonGia { get; set; }

    public virtual TblDienThoai MaDtNavigation { get; set; } = null!;

    public virtual TblHoaDon MaHdNavigation { get; set; } = null!;
}
