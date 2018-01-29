package com.cmw.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;

public class GetIp {

	public String getIpAddr(HttpServletRequest request) {
	    String ip = request.getHeader("x-forwarded-for");
	    if(null == ip || 0 == ip.length() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("Proxy-Client-IP");
	    }
	    if(null == ip || 0 == ip.length() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("WL-Proxy-Client-IP");
	    }
	    if(null == ip || 0 == ip.length() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getHeader("X-Real-IP");
	    }
	    if(null == ip || 0 == ip.length() || "unknown".equalsIgnoreCase(ip)) {
	        ip = request.getRemoteAddr();
	    }
	    return ip;
	}
	
	 public static void writeFile(String filename, String ip) {
	        try {
	        	Date date = new Date();
	        	long times = date.getTime();
	            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
	            String dateString = formatter.format(date);
	            PrintWriter out = new PrintWriter(new FileWriter(filename,true));
	            out.println(dateString+"\t\t"+ip);
	            out.close();
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	    }
	 
	  public static String readFile(String filename) {
	        File f = new File(filename);
	        String ip = null;
	        if (!f.exists()) {
	            writeFile(filename, ip);
	        }
	        try {
	            BufferedReader in = new BufferedReader(new FileReader(f));
	            try {
	                ip = in.readLine();
	            } catch (NumberFormatException e) {
	                e.printStackTrace();
	            } catch (IOException e) {
	                e.printStackTrace();
	            }
	        } catch (FileNotFoundException e) {
	            e.printStackTrace();
	        }
	        return ip;
	    }
}
