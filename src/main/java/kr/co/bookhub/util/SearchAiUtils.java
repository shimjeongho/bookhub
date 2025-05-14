package kr.co.bookhub.util;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class SearchAiUtils {

    private static final String API_KEY = "AIzaSyCdo2MnekdvjLFVME2DYs0GNj6KGJ_ZFvo"; // 여기에 API 키를 입력하세요

    // 선택 가능한 Gemini 모델:
    // "gemini-pro": 일반적인 프로 모델 (유료)
    // "gemini-pro-vision": 멀티모달 입력을 지원하는 프로 모델 (유료) - 이미지 검색 및 텍스트 생성 기능 포함
    // "gemini-ultra": 최고 성능을 자랑하는 울트라 모델 (유료) - 대규모 데이터 처리 및 복잡한 작업에 최적
    // "gemini-nano": 경량화된 모델 (무료) - 기본적인 텍스트 생성 및 간단한 작업에 적합
    // 요금 정보: https://ai.google.dev/pricing
    /* 기존 프롬포트
     * "인공지능(AI)이 어떻게 작동하는지 설명해 주세요\n" +
		                "가급적 전문용어보다는 이해하기 쉽도록 설명해 주세요.\n" +
		                "유익한 예제를 추가해주세요."
     */

    public static String aiSearch(String search) {
        String prompt = """
        		※ 주의사항:
        		- 키워드는 최대한 책을 구분할 수 있는 단어로 뽑아주세요.
				- 문장에 대해 검색에 필요한 핵심 키워드를 5~10개 뽑아주세요.
				- '책', '추천', '도서' 등과 같이 일반적이고 검색에 도움이 되지 않는 단어는 **제외**해 주세요.
				- 각 키워드는 사용자의 관심 주제나 도서의 주요 내용과 관련된 단어로 구성되어야 합니다.
				- 키워드는 **한 단어**로 구성되어야 합니다.
				- 모든 키워드를 **하나의 문자열**로 반환하고, 키워드 사이는 반드시 **한 칸 공백**으로만 구분해 주세요.
				- **JSON 배열 형식은 절대 사용하지 말고**, 순수 키워드 문자열만 출력해 주세요.
				- 질문에 대해 직접 답하거나 책을 추천하지 마세요.
				- 키워드는 사용자가 언급한 주제, 기술, 언어에 대해서만 뽑아주세요.

				문장: """ + search + """
						""";

        try {
            String response = callGeminiApi(prompt);
            
            return response;
            
        } catch (Exception e) {
            e.printStackTrace();
            
            return e.getMessage();
        }
    }
    
    private static List<String> jsonArrayToList(JSONArray jsonArray) {
        List<String> keywordList = new ArrayList<>();
        for (int i = 0; i < jsonArray.length(); i++) {
            keywordList.add(jsonArray.getString(i));
        }

        return keywordList;
    }

    private static String callGeminiApi(String prompt) throws Exception {
    	String urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=" + API_KEY;
        URL url = new URL(urlString);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("POST");
        conn.setRequestProperty("Content-Type", "application/json");
        conn.setDoOutput(true);

        // JSON 형식이 올바른지 확인
        String jsonInputString = String.format(
                "{\"contents\": [{\"parts\": [{\"text\": \"%s\"}]}]}",
                prompt.replace("\n", "\\n")
        );

        try (OutputStream os = conn.getOutputStream()) {
            byte[] input = jsonInputString.getBytes("utf-8");
            os.write(input, 0, input.length);
        }

        int responseCode = conn.getResponseCode();
        if (responseCode == 200) { // 성공적인 응답 코드 200을 체크
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream(), "utf-8"))) {
                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }

                // JSON 응답에서 메시지만 추출
                JSONObject jsonResponse = new JSONObject(response.toString());
                if (jsonResponse.has("candidates")) {
                    JSONArray candidates = jsonResponse.getJSONArray("candidates");
                    StringBuilder message = new StringBuilder();
                    for (int i = 0; i < candidates.length(); i++) {
                        JSONObject content = candidates.getJSONObject(i).getJSONObject("content");
                        JSONArray parts = content.getJSONArray("parts");
                        for (int j = 0; j < parts.length(); j++) {
                            message.append(parts.getJSONObject(j).getString("text")).append("\n");
                        }
                    }
                    return message.toString().trim();
                } else {
                    return "No candidates found in the response.";
                }
            }
        } else if (responseCode == 401) {
            throw new RuntimeException("Failed : HTTP error code : 401 Unauthorized. Please check your API key and permissions.");
        } else if (responseCode == 400) {
            try (BufferedReader br = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "utf-8"))) {
                StringBuilder response = new StringBuilder();
                String responseLine;
                while ((responseLine = br.readLine()) != null) {
                    response.append(responseLine.trim());
                }
                throw new RuntimeException("Failed : HTTP error code : 400 Bad Request. Response: " + response.toString());
            }
        } else {
            throw new RuntimeException("Failed : HTTP error code : " + responseCode);
        }
    }
}

/*
필요한 라이브러리의 Maven 정보:
<dependency>
    <groupId>org.json</groupId>
    <artifactId>json</artifactId>
    <version>20210307</version>
</dependency>
*/

/*
cURL 호출 예제:
curl -H 'Content-Type: application/json' \
     -d '{"contents":[{"parts":[{"text":"Explain how AI works"}]}]}' \
     -X POST 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=YOUR_API_KEY'
*/