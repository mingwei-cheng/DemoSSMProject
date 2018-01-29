package com.cmw.controller;

import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cmw.bean.Admin;
import com.cmw.bean.Msg;
import com.cmw.service.AdminService;

@Controller
public class AdminController {

	@Autowired
	private AdminService adminService;

	/**
	 * 查询所有管理员信息
	 * 
	 * @return
	 */
	@RequestMapping("/admin/{name}")
	@ResponseBody
	public Msg getAdmin(@PathVariable("name") String name, HttpServletResponse response, HttpServletRequest request) {
		String[] namePwd = name.split("-");
		List<Admin> list = adminService.adminLogin(namePwd[0]);
		if (list.size() > 0) {
			if (list.get(0).getAdName().equals(namePwd[1])) {
				Cookie cookie = new Cookie("login", namePwd[0]);
				cookie.setMaxAge(60 * 60);
				cookie.setPath("/");
				response.addCookie(cookie);
				return Msg.success();
			} else {
				return Msg.fail();
			}
		} else {
			return Msg.fail();
		}

	}

}
