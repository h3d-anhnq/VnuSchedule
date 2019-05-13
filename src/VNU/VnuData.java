package VNU;

import javax.swing.text.*;
import javax.swing.text.html.HTML;
import javax.swing.text.html.HTMLDocument;
import javax.swing.text.html.HTMLDocument.Iterator;
import javax.swing.text.html.HTMLEditorKit;

import DB.PersonalData;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.*;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class VnuData {
	//Request data
	private static final String USER_AGENT = "Mozilla/5.0";
	private static final String POST_URL = "http://dangkyhoc.vnu.edu.vn/dang-nhap";
	private static String USERNAME;
	private static String PASSWORD;
	private static String POST_PARAMS;
	public static int responseCode;
	//Subject data
	public List<String[]> data;
	public List<String[]> data_detail = new ArrayList<String[]>();
	public String[][] calendar = new String[10][8];
	//Student data
	public String name = "";
	public String birth = "";
	public String program = "";
	public String session = "";
	
	public VnuData(String username, String password) {
		this.USERNAME = username;
		this.PASSWORD = password;
		this.POST_PARAMS = "__RequestVerificationToken=8M0wzmVt4KIKxZaJJbpwSPA4WqfgxwAs0ZQiuxmblKemEHyGEka3rJ8gleCnyBnZtGkhm_zr07Dknng6XfzTj52Pqus1&LoginName="
				+ this.USERNAME + "&Password=" + this.PASSWORD;
		try {
			if (setSubjectList()) {
				convertData();
			}
		} catch (BadLocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public VnuData() {
		this.USERNAME = "16001742";
		this.PASSWORD = "25111998";
		this.POST_PARAMS = "__RequestVerificationToken=8M0wzmVt4KIKxZaJJbpwSPA4WqfgxwAs0ZQiuxmblKemEHyGEka3rJ8gleCnyBnZtGkhm_zr07Dknng6XfzTj52Pqus1&LoginName="
				+ this.USERNAME + "&Password=" + this.PASSWORD;

		try {
			setSubjectList();
			convertData();
			for (int i = 0; i < data.size(); i++) {
				Arrays.toString(data.toArray());
			}
		} catch (BadLocationException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public void setresponseCode(int responseCode) {
		this.responseCode = responseCode;
	}

	public static String sendPOST() throws IOException {
		URL obj = new URL(POST_URL);
		HttpURLConnection con = (HttpURLConnection) obj.openConnection();
		con.setRequestMethod("POST");
		con.setRequestProperty("User-Agent",
				"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36");
		con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
		con.setRequestProperty("Host", "dangkyhoc.vnu.edu.vn");
		con.setRequestProperty("Connection", "keep-alive");
		con.setRequestProperty("Origin", "http://dangkyhoc.vnu.edu.vn");
		con.setRequestProperty("Referer", "http://dangkyhoc.vnu.edu.vn/dang-nhap");
		con.setRequestProperty("Cookie",
				"__RequestVerificationToken=PlrzVF-sNd7JsCotj0oTzwkm7Uf7y6ye8UsAmGcIq_QxPUtHEWOjtA2wjG_P658BU_16hBd0HXxiO_ffzpjvO_Y2PSE1; ASP.NET_SessionId=hvkornmb1k1cwovr141dwoan");
		con.setRequestProperty("Content-Length", "156");
		con.setDoOutput(true);
		OutputStream os = con.getOutputStream();
		os.write(POST_PARAMS.getBytes());
		os.flush();
		os.close();
		con.getInputStream().close();
		URL get = new URL("http://dangkyhoc.vnu.edu.vn/xem-va-in-ket-qua-dang-ky-hoc/1?layout=main");
		con = (HttpURLConnection) get.openConnection();
		con.setRequestMethod("GET");
		con.setRequestProperty("User-Agent",
				"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.121 Safari/537.36");
		con.setRequestProperty("Host", "dangkyhoc.vnu.edu.vn");
		con.setRequestProperty("Connection", "keep-alive");
		con.setRequestProperty("Referer", "http://dangkyhoc.vnu.edu.vn/dang-nhap");
		con.setRequestProperty("Cookie",
				"__RequestVerificationToken=PlrzVF-sNd7JsCotj0oTzwkm7Uf7y6ye8UsAmGcIq_QxPUtHEWOjtA2wjG_P658BU_16hBd0HXxiO_ffzpjvO_Y2PSE1; ASP.NET_SessionId=hvkornmb1k1cwovr141dwoan");
		String encode = con.getContentEncoding();
		URL url = con.getURL();
		int responseCode = con.getResponseCode();
		if (responseCode == HttpURLConnection.HTTP_OK && url.toString()
				.compareTo("http://dangkyhoc.vnu.edu.vn/xem-va-in-ket-qua-dang-ky-hoc/1?layout=main") == 0) { // success
			BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream(), "utf-8"));
			String inputLine;
			StringBuffer response = new StringBuffer();
			while ((inputLine = in.readLine()) != null) {
				response.append(inputLine);
			}
			in.close();
			// Write result
			String str = response.toString();
			BufferedWriter writer = new BufferedWriter(
					new FileWriter("E:\\ItPlusWebProject\\End\\dangkyhoc.html"));
			writer.write(str);
			writer.close();
			return str;
		} else {
			return null;
		}
	}

	public boolean setSubjectList() throws BadLocationException, IOException {
		String txt = VnuData.sendPOST();
		if (txt != null) {
			this.responseCode = 200;
			Pattern p = Pattern
					.compile("<table style=\"border:none; width: 100%; border-collapse:collapse;\">.*?</table>");
			Matcher m = p.matcher(txt);
			while (m.find()) {
				String tag = m.group();
				HTMLEditorKit htmlKit = new HTMLEditorKit();
				HTMLDocument htmlDoc = (HTMLDocument) htmlKit.createDefaultDocument();
				htmlKit.read(new StringReader(tag), htmlDoc, 0);
				// Parse
				ElementIterator iterator = new ElementIterator(htmlDoc);
				Element element;
				while ((element = iterator.next()) != null) {
					AttributeSet as = element.getAttributes();
					Object name = as.getAttribute(StyleConstants.NameAttribute);
					if (name == HTML.Tag.TABLE) {
						StringBuffer sb = new StringBuffer();
						sb.append(name).append(": ");
						int count = element.getElementCount();
						for (int i = 0; i < count; i++) {
							Element child = element.getElement(i);
							int startOffset = child.getStartOffset();
							int endOffset = child.getEndOffset();
							int length = endOffset - startOffset;
							sb.append(htmlDoc.getText(startOffset, length));
						}
						String[] sb_string = sb.toString().split("\n");
						int i = 0;
						List<String[]> data = new ArrayList<>();
						while (i < sb_string.length - 10) {
							String[] data_tmp = new String[10];
							for (int j = 0; j < 10; j++) {
								if (i >= 10) {
									data_tmp[j] = sb_string[i];
								}
								i++;
							}
							if (i > 10) {
								data.add(data_tmp);
							}
						}
						this.data = data;
					}
				}
			}

			Pattern p1 = Pattern.compile("Họ và tên</td>                <td><b>.*?</b>");
			Matcher m1 = p1.matcher(txt);
			while (m1.find()) {
				String tag = m1.group();
				String name = tag.split("<b>")[1].split("<")[0];
				this.name = name;
			}
			
			p1 = Pattern.compile("Ngày sinh</td>                <td><b>.*?</b>");
			m1 = p1.matcher(txt);
			while (m1.find()) {
				String tag = m1.group();
				String birth = tag.split("<b>")[1].split("<")[0];
				this.birth = birth;
			}
			
			p1 = Pattern.compile("Chương trình đào tạo</td>                <td><b>.*?</b>");
			m1 = p1.matcher(txt);
			while (m1.find()) {
				String tag = m1.group();
				String program = tag.split("<b>")[1].split("<")[0];
				this.program = program;
			}
			
			p1 = Pattern.compile("Khóa</td>                <td><b>.*?</b>");
			m1 = p1.matcher(txt);
			while (m1.find()) {
				String tag = m1.group();
				String session = tag.split("<b>")[1].split("<")[0];
				this.session = session;
			}
			return true;
		} else {
			this.responseCode = 404;
			return false;
		}
	}

	public String[] getSubjectByid(String i) {
		return data.get(Integer.parseInt(i) - 1);
	}

	public void merge_with_db(List db_result) {
		for (int i = 0; i < db_result.size(); i++) {
			String[] result = (String[]) db_result.get(i);
//			System.out.println(Arrays.toString(result));
			int date = Integer.valueOf(result[6]) - 1;
			int start = Integer.valueOf(result[4]);
			int last = Integer.valueOf(result[5]);
			calendar[start - 1][date] = last + "/" + result[0] + "/DBN";
			for (int k = 1; k < last; k++) {
				calendar[start - 1 + k][date] = "KKKKKKK";
			}
		}
	}

	public void convertData() {
		//Make all cells 0
		for (int i = 0; i < calendar.length; i++) {
			for (int j = 0; j < calendar[i].length; j++) {
				if (j == 0) {
					calendar[i][j] = Integer.toString(i + 1);
				} else {
					calendar[i][j] = "0";
				}
			}
		}
		//For indexing the detail table
		int detail_index = 1;
		//Convert the data
		for (int i = 0; i < this.data.size(); i++) {
			String[] subject = this.data.get(i);
//			System.out.println(Arrays.toString(subject));
			// Convert date
			String[] date = subject[7].split(",");
			// Convert time
			String[] time = subject[8].split(",");
			// Insert To Calendar
			for (int j = 0; j < date.length; j++) {
				// Time start and end
				String start = time[j].split("-")[0].replace(" ", "");
				String end = time[j].split("-")[1].replace(" ", "");
				int last = Integer.parseInt(end) - Integer.parseInt(start) + 1;
				String last_string = Integer.toString(last);
				// Subject ID
				String id = Integer.toString(i);
				// Date
				int index_date = Integer.valueOf(date[j].charAt(1)) - 49;
				if (date[j].compareTo("CN") == 0) {
					index_date = 7;
				}
				//Fill the calendar
				calendar[Integer.parseInt(start) - 1][index_date] = last_string + "/" + Integer.toString(detail_index) + "/VNU";
				for (int k = 1; k < last; k++) {
					calendar[Integer.parseInt(start) - 1 + k][index_date] = "KKKKKKK";
				}
				//Make the detail data
				String[] detail = new String[7];
				detail[0] = Integer.toString(detail_index);
				detail[1] = subject[1];
				detail[2] = subject[2];
				detail[3] = subject[3];
				detail[4] = subject[4];
				detail[5] = date[j];
				detail[6] = time[j];
				detail_index++;
				data_detail.add(detail);
			}
		}
//		System.out.println(calendar.length);
		
	}
	
	public String[] getSubjectDetail(String index) {
		return data_detail.get(Integer.parseInt(index)-1);
	}
	
	public void printCalendar() {
		for (int i = 0; i <calendar.length; i++) {
			System.out.println(Arrays.toString(calendar[i]));
		}
	}

//	public static void main(String[] args) {
//		VnuData vnu = new VnuData("16001742", "25111998");
//		System.out.println(vnu.responseCode);
//		PersonalData db = new PersonalData();
//		db.get_data_by_week(1, 0);
//		List<String[]> result = db.list_rs;
//		for (int i = 0; i <result.size(); i++) {
//			System.out.println(Arrays.toString(result.get(i)));
//		}
//		
//		vnu.merge_with_db(result);
//		vnu.printCalendar();
//	}
}
