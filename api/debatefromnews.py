from flask import Flask, request, jsonify,Blueprint
import requests
from bs4 import BeautifulSoup

debatefromnews = Blueprint('debatefromnews',__name__)

# 定义目标API的固定参数
API_URL = "https://maas-cn-southwest-2.modelarts-maas.com/v1/infers/8a062fd4-7367-4ab4-a936-5eeb8fb821c4/v1/chat/completions"
HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer YOVu9vLFu3JG5Pl7ruiHud2trqaUNHojAcJVMFcfSUmOhBIJEMWW5Dui9oB1LIImZFSS2tszw51jTDBoqO8Ppg"
}

@debatefromnews.route('/api/generate_debate', methods=['GET'])
def generate_debate():
    # 获取URL参数
    target_url = request.args.get('url')
    if not target_url:
        return jsonify({"error": "Missing URL parameter"}), 400

    try:
        # 设置请求头，模拟浏览器访问
        headers = {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36'
        }
        # 获取目标网页内容
        response = requests.get(target_url, headers=headers)
        response.raise_for_status()
        # 自动处理编码（根据网页内容自适应）
        response.encoding = response.apparent_encoding
        # html_content = response.text
        # 使用BeautifulSoup解析并过滤
        soup = BeautifulSoup(response.text, 'html.parser')

        # 移除所有图片标签
        for img in soup.find_all('img'):
            img.decompose()

        # 移除其他可能包含图片的标签（按需添加）
        for noscript in soup.find_all('noscript'):
            noscript.decompose()

        # 提取纯文本并优化格式
        text = soup.get_text(separator='\n', strip=True)

        # 清理多余空行
        html_content = '\n'.join([line for line in text.split('\n') if line.strip()])
    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"Failed to fetch URL: {str(e)}"}), 500

    try:
        # 构造请求数据\
        jsontype="{\"debate_topic\":\"辩论赛主题\",\"pros\":{\"team\":\"正反\",\"argument\":\"正反立场\"},\"cons\":{\"team\":\"反方\",\"argument\":\"反方立场\"},\"rounds\":[{\"round\":1,\"pro_position\":\"正反论点\",\"pro_evidence\":\"正反论点支持证据\",\"con_position\":\"反方论点\",\"con_evidence\":\"反方论点支持证据\"},{\"round\":2,\"pro_position\":\"正反论点\",\"pro_evidence\":\"正反论点支持证据\",\"con_position\":\"反方论点\",\"con_evidence\":\"反方论点支持证据\"}]}"
        payload = {
            "model": "DeepSeek-R1",
            "messages": [
                {
                    "role": "user",
                    "content": f"网页HTML内容：\n{html_content}\n请根据这个网页内容生成一个辩论赛主题，并根据正反双方的立场，生成10个辩论轮次，输出格式为标准化的json数据，不要输出任何多余的文本，每个轮次包含一个正方论点，一个反方论点，一个正方论点支持证据，一个反方论点支持证据。标准的json格式如下:\n{jsontype}\n"
                }
            ],
            "stream": False,
            "temperature": 0.6
        }

        # 调用目标API
        api_response = requests.post(API_URL, headers=HEADERS, json=payload)
        api_response.raise_for_status()
        return jsonify(api_response.json())
    except requests.exceptions.RequestException as e:
        return jsonify({"error": f"API request failed: {str(e)}"}), 500
    except ValueError:
        return jsonify({"error": "Invalid response from API"}), 500
