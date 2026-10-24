using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using PhoneStoreAPI.Entities;
using PhoneStoreAPI.Models;

namespace PhoneStoreAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class HoaDonController : ControllerBase
    {
        private readonly PhoneStoreContext _con;

        public HoaDonController(PhoneStoreContext context)
        {
            _con = context;
        }

        // POST api/HoaDon -> thanh toán giỏ hàng, lưu hóa đơn + chi tiết
        [HttpPost]
        public IActionResult ThanhToan(HoaDonRequest request)
        {
            if (request.ChiTiet == null || request.ChiTiet.Count == 0)
            {
                return BadRequest(new { message = "Giỏ hàng trống, không thể thanh toán." });
            }

            try
            {
                // Gộp các dòng trùng mã (khách bấm thêm 1 máy nhiều lần)
                var gop = request.ChiTiet
                    .GroupBy(c => c.MaDT.Trim())
                    .Select(g => new { MaDT = g.Key, SoLuong = g.Sum(c => c.SoLuong) })
                    .ToList();

                // Lấy giá từ database (không tin giá gửi từ app)
                var dienThoais = _con.TblDienThoais.ToList().ToDictionary(d => d.MaDt);

                var khongCo = gop.Where(c => !dienThoais.ContainsKey(c.MaDT)).Select(c => c.MaDT).ToList();
                if (khongCo.Count > 0)
                {
                    return BadRequest(new { message = "Không có điện thoại mã: " + string.Join(", ", khongCo) });
                }

                var hoaDon = new TblHoaDon
                {
                    NgayLap = DateTime.Now,
                    TenKhachHang = request.TenKhachHang
                };

                foreach (var c in gop)
                {
                    var dt = dienThoais[c.MaDT];
                    hoaDon.TblChiTietHoaDons.Add(new TblChiTietHoaDon
                    {
                        MaDt = dt.MaDt,
                        SoLuong = c.SoLuong,
                        DonGia = dt.Gia
                    });
                }
                hoaDon.TongTien = hoaDon.TblChiTietHoaDons.Sum(c => c.SoLuong * c.DonGia);

                // 1 lần SaveChanges = hóa đơn và chi tiết được lưu trong cùng 1 transaction
                _con.TblHoaDons.Add(hoaDon);
                _con.SaveChanges();

                return Ok(new
                {
                    message = "Bạn đã thanh toán xong giỏ hàng",
                    maHD = hoaDon.MaHd,
                    ngayLap = hoaDon.NgayLap,
                    tongTien = hoaDon.TongTien
                });
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = "Thanh toán thất bại", error = ex.InnerException?.Message ?? ex.Message });
            }
        }

        // GET api/HoaDon -> danh sách hóa đơn đã lưu (mới nhất trước)
        [HttpGet]
        public IActionResult GetAll()
        {
            var list = _con.TblHoaDons
                .Include(h => h.TblChiTietHoaDons)
                    .ThenInclude(c => c.MaDtNavigation)
                .OrderByDescending(h => h.MaHd)
                .ToList()
                .Select(MapHoaDon)
                .ToList();
            return Ok(list);
        }

        // GET api/HoaDon/1 -> chi tiết 1 hóa đơn
        [HttpGet("{id:int}")]
        public IActionResult GetById(int id)
        {
            var h = _con.TblHoaDons
                .Include(x => x.TblChiTietHoaDons)
                    .ThenInclude(c => c.MaDtNavigation)
                .FirstOrDefault(x => x.MaHd == id);
            if (h == null)
            {
                return NotFound(new { message = "Không có hóa đơn: " + id });
            }
            return Ok(MapHoaDon(h));
        }

        private static object MapHoaDon(TblHoaDon h) => new
        {
            maHD = h.MaHd,
            ngayLap = h.NgayLap,
            tenKhachHang = h.TenKhachHang,
            tongTien = h.TongTien,
            chiTiet = h.TblChiTietHoaDons.Select(c => new
            {
                maDT = c.MaDt,
                tenDT = c.MaDtNavigation?.TenDt,
                soLuong = c.SoLuong,
                donGia = c.DonGia,
                thanhTien = c.SoLuong * c.DonGia
            })
        };
    }
}
