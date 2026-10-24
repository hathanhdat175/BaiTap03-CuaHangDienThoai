using Microsoft.AspNetCore.Mvc;
using PhoneStoreAPI.Entities;
using PhoneStoreAPI.Models;

namespace PhoneStoreAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class DienThoaiController : ControllerBase
    {
        private readonly PhoneStoreContext _con;

        public DienThoaiController(PhoneStoreContext context)
        {
            _con = context;
        }

        // GET api/DienThoai -> danh sách điện thoại cửa hàng đang bán
        [HttpGet]
        public IActionResult GetAll()
        {
            var list = _con.TblDienThoais
                .OrderBy(x => x.MaDt)
                .Select(x => new DienThoaiDto
                {
                    MaDT = x.MaDt,
                    TenDT = x.TenDt,
                    MoTa = x.MoTa,
                    Gia = x.Gia,
                    HinhAnh = x.HinhAnh
                })
                .ToList();
            return Ok(list);
        }

        // GET api/DienThoai/DT01 -> chi tiết 1 điện thoại
        [HttpGet("{id}")]
        public IActionResult GetById(string id)
        {
            var x = _con.TblDienThoais.FirstOrDefault(d => d.MaDt == id);
            if (x == null)
            {
                return NotFound(new { message = "Không có điện thoại mã: " + id });
            }
            return Ok(new DienThoaiDto
            {
                MaDT = x.MaDt,
                TenDT = x.TenDt,
                MoTa = x.MoTa,
                Gia = x.Gia,
                HinhAnh = x.HinhAnh
            });
        }

        // GET api/DienThoai/banchay?top=5 -> sản phẩm được lựa chọn nhiều nhất
        // (tính theo tổng số lượng trong các hóa đơn đã lưu)
        [HttpGet("banchay")]
        public IActionResult GetBanChay(int top = 5)
        {
            var thongKe = _con.TblChiTietHoaDons
                .GroupBy(c => c.MaDt)
                .Select(g => new { MaDt = g.Key, SoLuong = g.Sum(c => c.SoLuong) })
                .OrderByDescending(g => g.SoLuong)
                .Take(top)
                .ToList();

            var dienThoais = _con.TblDienThoais.ToList().ToDictionary(d => d.MaDt);

            var list = thongKe
                .Where(t => dienThoais.ContainsKey(t.MaDt))
                .Select(t =>
                {
                    var x = dienThoais[t.MaDt];
                    return new DienThoaiDto
                    {
                        MaDT = x.MaDt,
                        TenDT = x.TenDt,
                        MoTa = x.MoTa,
                        Gia = x.Gia,
                        HinhAnh = x.HinhAnh,
                        SoLuongDaBan = t.SoLuong
                    };
                })
                .ToList();

            return Ok(list);
        }
    }
}
