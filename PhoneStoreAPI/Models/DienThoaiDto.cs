namespace PhoneStoreAPI.Models
{
    // Dữ liệu điện thoại trả về cho Flutter
    // JSON: { "maDT", "tenDT", "moTa", "gia", "hinhAnh", "soLuongDaBan" }
    public class DienThoaiDto
    {
        public string MaDT { get; set; } = string.Empty;
        public string TenDT { get; set; } = string.Empty;
        public string? MoTa { get; set; }
        public decimal Gia { get; set; }
        public string? HinhAnh { get; set; }
        public int SoLuongDaBan { get; set; }
    }
}
