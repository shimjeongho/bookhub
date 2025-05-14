package kr.co.bookhub.util;

import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class StringUtils {

	private static DecimalFormat decimalFormat = new DecimalFormat("##,###");
	private static DecimalFormat decimalFormat2 = new DecimalFormat("#,###.#");
	private static SimpleDateFormat detailDateFormat = new SimpleDateFormat("yyyy년 M월 d일 a h시 m분 s초");
	private static SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
	
	
	/**
	 * 값을 전달받아서, 해당 값이 null이면 defaultValue를 반환한다.
	 * @param value null일 가능성이 있는 문자열
	 * @param defaultValue 기본값
	 * @return 문자열, null일때는 기본값
	 */
	public static String nullToStr(String value, String defaultValue) {
		if (value == null) {
			return defaultValue;
		}
		return value.trim();
	}
	
	/**
	 * 전달받은 값이 null이면 빈 문자열을 반환한다.
	 * @param value null일 가능성이 있는 문자열
	 * @return 문자열 혹은 빈문자열
	 */
	public static String nullToBlank(String value) {
		return nullToStr(value, "");
	}
	
	
	/**
	 * 날짜 형식의 문자열을 Date로 변환한다.
	 * @param str 날짜형식의 문자열
	 * @return Date
	 * @throws ParseException
	 */
	public static Date strToDate(String str) throws ParseException {
		if (str ==  null || str.isBlank()) {
			return null;
		}
		
		return simpleDateFormat.parse(str);
	}
	
	/**
	 * 날짜를 전달받아서 
	 * "2024년 1월 1일 오전 9시 10분 20초" 형식의 문자열로 반환한다.
	 * @param date 날짜
	 * @return "2024년 1월 1일 오전 9시 10분 20초" 형식의 문자열
	 */
	public static String detailDate(Date date) {
		if (date == null) {
			return "";
		}
		return detailDateFormat.format(date);
	}
	
	
	
	/**
	 * 날짜를 전달받아서 "2024-01-21" 형식의 문자열로 반환한다.
	 * @param date 날짜
	 * @return "2024-01-21" 형식의 문자열
	 */
	public static String simpleDate(Date date) {
		if (date == null) {
			return "";
		}
		return simpleDateFormat.format(date);
		
	}
	
	/**
	 * 정수를 ,가 포함된 텍스트로 변환한다.
	 * @param number 숫자
	 * @return 3자리마다 ,가 포함된 숫자형식 텍스트
	 */
	public static String commaWithNumber(int number) {
		return decimalFormat.format(number);
	}
	
	/**
	 * 숫자형식의 문자열을 전달받아서 정수로 변환 후 반환한다.
	 * @param str 숫자형식의 문자열
	 * @param defaultValue 기본값
	 * @return 숫자, 유효한 형식이 아니면 기본값을 반환한다.
	 */
	public static int strToInt(String str, int defaultValue) {
		if (str == null) {
			return defaultValue;
		}
		str = str.trim();
		if (str.isEmpty()) {
			return defaultValue;
		}
		
		try {
			return Integer.parseInt(str);
		} catch (NumberFormatException ex) {
			return defaultValue;
		}
	}
	
	/**
	 * 문자열을 정수로 변환해서 반환한다.
	 * @param str 숫자로 구성된 문자열
	 * @return 정수값
	 */
	public static Integer strToInt(String str) {
		if (str == null) {
			throw new IllegalArgumentException("null값은 숫자로 변환할 수 없다.");
		}
		str = str.trim();
		if (str.isEmpty()) {
			throw new IllegalArgumentException("빈 문자열은 숫자로 변환할 수 없다.");
		}
		return Integer.parseInt(str);
	}
	
	/**
	 * String[]을 int[]로 변환해서 반환한다.
	 * @param values 문자열 배열
	 * @return 정수 배열
	 */
	public static int[] strToInt(String[] values) {
		/*
		 * ["1", "4", "10"] -> [1, 4, 10]
		 */
		int[] numbers = new int[values.length];
		
		for (int index = 0; index < values.length; index++) {
			numbers[index] = strToInt(values[index]);
		}
		
		return numbers;
	}
	
	/**
	 * 평점에 맞는 별을 반환한다.
	 * @param rating 평점
	 * @return 별
	 */
	public static String toStar(double rating) {
		if (rating < 1) {
			return "☆☆☆☆☆";
		} else if (rating < 2) {
			return "★☆☆☆☆";
		} else if (rating < 3) {
			return "★★☆☆☆";
		} else if (rating < 4) {
			return "★★★☆☆";
		} else if (rating < 5) {
			return "★★★★☆";
		} else {
			return "★★★★★";
		}
	}
	
	/**
	 * 실수를 소수점 첫번째 값으로 반올림한다.
	 * @param value 실수값
	 * @return 소숫점 첫번째자리로 반올림된 실수값
	 */
	public static double round(double value) {
		String str = decimalFormat2.format(value);
		return Double.valueOf(str);
	}
		
	/**
	 * text와 text의 최대 글자 길이를 전달 받아서, 
	 * text의 길이를 최대 글자 정도까지만 표시하고, 그 이상이되는 글자들은 "..."으로 표시한다. 
	 * @param text
	 * @param maxLength
	 * @return
	 */
	public static String truncate (String text, int maxLength) {
		
		if(text == null) {
			return null;
		}
		if(text.length() > maxLength) {
			return text.substring(0,maxLength) + "...";
		}
		
		return text;

	}

}
