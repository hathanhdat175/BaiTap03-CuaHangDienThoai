using System.ComponentModel.DataAnnotations;

namespace PhoneStoreAPI.Models
{
    // Dữ liệu Flutter gửi lên khi bấm Thanh toán
    // { "tenKhachHang": "...", "chiTiet": [ { "maDT": "DT01", "soLuong": 1 }, ... ] }
    public class HoaDonRequest
    {
        [MaxLength(100)]
        public string? TenKhachHang { get; set; }

        [Required]
        [MinLength(1, ErrorMessage = "Giỏ hàng trống")]
        public List<ChiTietRequest> ChiTiet { get; set; } = new();
    }

    public class ChiTietRequest
    {
        [Required]
        [MaxLength(10)]
        public string MaDT { get; set; } = string.Empty;

        [Range(1, 1000)]
        public int SoLuong { get; set; } = 1;
    }
}
