import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  InAppWebViewController? webViewController;
  
  final String cytoscapeHtml = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>의료 기록 그래프</title>
  <style>
    body {
      margin: 0;
      padding: 20px;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      background-color: #f8f9fa;
    }
    #cy {
      width: 100%;
      height: 80vh;
      border: 2px solid #e0e6ed;
      border-radius: 12px;
      background-color: white;
      box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }
    .header {
      text-align: center;
      margin-bottom: 20px;
    }
    .header h2 {
      color: #2c3e50;
      margin: 0;
      font-size: 24px;
      font-weight: 600;
    }
    .controls {
      display: flex;
      justify-content: center;
      gap: 10px;
      margin-bottom: 15px;
      flex-wrap: wrap;
    }
    .btn {
      padding: 8px 16px;
      border: none;
      border-radius: 6px;
      cursor: pointer;
      font-size: 14px;
      font-weight: 500;
      transition: all 0.2s;
    }
    .btn-primary {
      background-color: #3498db;
      color: white;
    }
    .btn-primary:hover {
      background-color: #2980b9;
    }
    .btn-secondary {
      background-color: #95a5a6;
      color: white;
    }
    .btn-secondary:hover {
      background-color: #7f8c8d;
    }
    .loading {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 80vh;
      font-size: 18px;
      color: #7f8c8d;
    }
    .error {
      display: flex;
      justify-content: center;
      align-items: center;
      height: 80vh;
      font-size: 16px;
      color: #e74c3c;
      text-align: center;
    }
    .legend {
      display: flex;
      justify-content: center;
      gap: 20px;
      margin-bottom: 15px;
      flex-wrap: wrap;
    }
    .legend-item {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 12px;
    }
    .legend-color {
      width: 16px;
      height: 16px;
      border-radius: 50%;
      border: 2px solid rgba(0,0,0,0.1);
    }
    .tooltip {
      position: absolute;
      background-color: rgba(0, 0, 0, 0.9);
      color: white;
      padding: 12px 16px;
      border-radius: 8px;
      font-size: 13px;
      max-width: 300px;
      z-index: 1000;
      pointer-events: none;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
      line-height: 1.4;
      white-space: pre-wrap;
      word-wrap: break-word;
    }
    .tooltip::after {
      content: '';
      position: absolute;
      bottom: -10px;
      left: 50%;
      margin-left: -5px;
      border-width: 5px;
      border-style: solid;
      border-color: rgba(0, 0, 0, 0.9) transparent transparent transparent;
    }
    
    /* 모달 스타일 */
    .modal {
      display: none;
      position: fixed;
      z-index: 2000;
      left: 0;
      top: 0;
      width: 100%;
      height: 100%;
      background-color: rgba(0, 0, 0, 0.5);
      backdrop-filter: blur(4px);
    }
    
    .modal-content {
      background-color: #ffffff;
      margin: 5% auto;
      border-radius: 16px;
      width: 90%;
      max-width: 500px;
      box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3);
      animation: modalSlideIn 0.3s ease-out;
      overflow: hidden;
    }
    
    @keyframes modalSlideIn {
      from {
        opacity: 0;
        transform: translateY(-50px) scale(0.9);
      }
      to {
        opacity: 1;
        transform: translateY(0) scale(1);
      }
    }
    
    .modal-header {
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: white;
      padding: 20px 24px;
      position: relative;
    }
    
    .modal-header h3 {
      margin: 0;
      font-size: 20px;
      font-weight: 600;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    
    .modal-header .date {
      font-size: 14px;
      opacity: 0.9;
      margin-top: 4px;
    }
    
    .close {
      position: absolute;
      right: 20px;
      top: 50%;
      transform: translateY(-50%);
      color: white;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
      width: 32px;
      height: 32px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.2);
      transition: background 0.2s;
    }
    
    .close:hover {
      background: rgba(255, 255, 255, 0.3);
    }
    
    .modal-body {
      padding: 24px;
    }
    
    .info-section {
      margin-bottom: 20px;
    }
    
    .info-label {
      font-weight: 600;
      color: #2c3e50;
      font-size: 14px;
      margin-bottom: 8px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    
    .info-content {
      background-color: #f8f9fa;
      padding: 12px 16px;
      border-radius: 8px;
      border-left: 4px solid #3498db;
      line-height: 1.5;
      font-size: 14px;
      color: #34495e;
    }
    
    .type-badge {
      display: inline-block;
      padding: 4px 12px;
      border-radius: 20px;
      font-size: 12px;
      font-weight: 600;
      color: white;
      margin-top: 8px;
    }
    
    .type-treatment { background-color: #e74c3c; }
    .type-examination { background-color: #3498db; }
    .type-consultation { background-color: #2ecc71; }
    .type-management { background-color: #f39c12; }
    .type-other { background-color: #9b59b6; }
  </style>
</head>
<body>
  <div class="header">
    <h2>환자 의료 기록 타임라인</h2>
  </div>
  
  <div class="legend" id="legend">
    <div class="legend-item">
      <div class="legend-color" style="background-color: #e74c3c;"></div>
      <span>진료</span>
    </div>
    <div class="legend-item">
      <div class="legend-color" style="background-color: #3498db;"></div>
      <span>검사</span>
    </div>
    <div class="legend-item">
      <div class="legend-color" style="background-color: #2ecc71;"></div>
      <span>상담</span>
    </div>
    <div class="legend-item">
      <div class="legend-color" style="background-color: #f39c12;"></div>
      <span>관리</span>
    </div>
    <div class="legend-item">
      <div class="legend-color" style="background-color: #9b59b6;"></div>
      <span>기타</span>
    </div>
  </div>
  
  <div class="controls">
    <button class="btn btn-primary" onclick="refreshData()">새로고침</button>
    <button class="btn btn-primary" onclick="calculateSimilarity()">유사도 계산</button>
    <button class="btn btn-secondary" onclick="changeLayout('timeline')">타임라인</button>
    <button class="btn btn-secondary" onclick="changeLayout('circle')">원형</button>
    <button class="btn btn-secondary" onclick="changeLayout('grid')">격자</button>
    <button class="btn btn-secondary" onclick="changeLayout('cose')">자동</button>
  </div>

  <div id="loading" class="loading" style="display: block;">
    데이터를 불러오는 중...
  </div>
  
  <div id="error" class="error" style="display: none;">
    데이터를 불러오는데 실패했습니다.<br>
    서버가 실행되고 있는지 확인해주세요.
  </div>

  <div id="cy" style="display: none;"></div>
  
  <!-- 툴팁 -->
  <div id="tooltip" class="tooltip" style="display: none;"></div>
  
  <!-- 모달 -->
  <div id="detailModal" class="modal">
    <div class="modal-content">
      <div class="modal-header">
        <h3 id="modalTitle">📋 의료 기록 상세정보</h3>
        <div class="date" id="modalDate"></div>
        <span class="close" onclick="closeModal()">&times;</span>
      </div>
      <div class="modal-body">
        <div class="info-section">
          <div class="info-label">📝 상세 내용</div>
          <div class="info-content" id="modalContent"></div>
        </div>
        <div class="info-section">
          <div class="info-label">🆔 기록 ID</div>
          <div class="info-content" id="modalId"></div>
        </div>
        <div class="info-section">
          <div class="info-label">🏷️ 유형</div>
          <div id="modalType"></div>
        </div>
      </div>
    </div>
  </div>

  <script src="https://unpkg.com/cytoscape@3.27.0/dist/cytoscape.min.js"></script>
  <script>
    let cy;
    let medicalData = [];
    
    // 의료 기록 타입별 색상 매핑
    const getNodeTypeAndColor = (name) => {
      const lowerName = name.toLowerCase();
      if (lowerName.includes('진료') || lowerName.includes('치료')) {
        return { type: 'treatment', color: '#e74c3c' };
      } else if (lowerName.includes('검사') || lowerName.includes('검진')) {
        return { type: 'examination', color: '#3498db' };
      } else if (lowerName.includes('상담') || lowerName.includes('상담')) {
        return { type: 'consultation', color: '#2ecc71' };
      } else if (lowerName.includes('관리') || lowerName.includes('관리')) {
        return { type: 'management', color: '#f39c12' };
      } else {
        return { type: 'other', color: '#9b59b6' };
      }
    };

    // API에서 데이터 불러오기
    async function loadMedicalData() {
      try {
        document.getElementById('loading').style.display = 'block';
        document.getElementById('error').style.display = 'none';
        document.getElementById('cy').style.display = 'none';
        
        // 노드 데이터 불러오기
        const nodesResponse = await fetch('http://localhost:8000/graph/nodes', {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'Origin': 'http://localhost'
          }
        });
        
        if (!nodesResponse.ok) {
          throw new Error(`Nodes HTTP error! status: \${nodesResponse.status}`);
        }
        
        medicalData = await nodesResponse.json();
        console.log('의료 데이터 로드 완료:', medicalData);
        
        // 엣지 데이터 불러오기
        const edgesResponse = await fetch('http://localhost:8000/graph/edges', {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'Origin': 'http://localhost'
          }
        });
        
        if (!edgesResponse.ok) {
          throw new Error(`Edges HTTP error! status: \${edgesResponse.status}`);
        }
        
        const edgeData = await edgesResponse.json();
        console.log('엣지 데이터 로드 완료:', edgeData);
        
        if (medicalData && medicalData.length > 0) {
          createGraph(edgeData);
        } else {
          throw new Error('데이터가 비어있습니다.');
        }
        
      } catch (error) {
        console.error('데이터 로드 실패:', error);
        document.getElementById('loading').style.display = 'none';
        document.getElementById('error').style.display = 'block';
        document.getElementById('cy').style.display = 'none';
      }
    }

    // 그래프 생성
    function createGraph(edgeData) {
      try {
        // 데이터를 시간순으로 정렬
        const sortedData = [...medicalData].sort((a, b) => 
          new Date(a.datetime) - new Date(b.datetime)
        );
        
        // 노드 생성
        const nodes = sortedData.map(item => {
          const { type, color } = getNodeTypeAndColor(item.name);
          const date = new Date(item.datetime);
          const dateStr = date.toLocaleDateString('ko-KR') + ' ' + 
                         date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
          
          // content가 없거나 빈 문자열인 경우 기본값 설정
          const content = item.content && item.content.trim() !== '' 
            ? item.content 
            : '상세 내용이 없습니다.';
          
          return {
            data: {
              id: item.id,
              label: item.name,
              type: type,
              datetime: item.datetime,
              content: content,
              dateStr: dateStr,
              fullInfo: `\${item.name}\\n\${dateStr}\\n\${content}`
            }
          };
        });
        
        // 서버에서 받아온 엣지 데이터로 엣지 생성
        // 노드 이름으로 ID를 찾기 위한 맵 생성
        const nameToIdMap = {};
        sortedData.forEach(item => {
          nameToIdMap[item.name] = item.id;
        });
        
        console.log('노드 이름-ID 매핑:', nameToIdMap);
        console.log('엣지 데이터:', edgeData);
        
        const edges = (edgeData || []).filter(edge => {
          // 소스와 타겟 노드가 모두 존재하는지 확인
          const sourceExists = nameToIdMap[edge.from_node];
          const targetExists = nameToIdMap[edge.to_node];
          
          
          
          return sourceExists && targetExists;
        }).map(edge => {
          let label = '';
          let edgeType = 'related';
          
          if (edge.type === 'IS_SAMEDATE') {
            label = '동일 날짜';
            edgeType = 'samedate';
          } else if (edge.type === 'IS_TIMELINE') {
            label = '타임라인';
            edgeType = 'timeline';
          } else {
            label = edge.type || '연결';
            edgeType = 'related';
          }
          
          return {
            data: {
              source: nameToIdMap[edge.from_node],
              target: nameToIdMap[edge.to_node],
              label: label,
              type: edgeType,
              score: edge.score,
              edgeType: edge.type
            }
          };
        });

        // Cytoscape 초기화
        cy = cytoscape({
          container: document.getElementById('cy'),
          elements: [...nodes, ...edges],
          
          style: [
            // 노드 스타일 - 진료
            {
              selector: 'node[type="treatment"]',
              style: {
                'label': 'data(label)',
                'background-color': '#e74c3c',
                'text-valign': 'center',
                'text-halign': 'center',
                'color': '#fff',
                'font-size': '11px',
                'font-weight': 'bold',
                'width': 80,
                'height': 80,
                'border-width': 3,
                'border-color': '#c0392b',
                'text-wrap': 'wrap',
                'text-max-width': '70px'
              }
            },
            // 노드 스타일 - 검사
            {
              selector: 'node[type="examination"]',
              style: {
                'label': 'data(label)',
                'background-color': '#3498db',
                'text-valign': 'center',
                'text-halign': 'center',
                'color': '#fff',
                'font-size': '11px',
                'font-weight': 'bold',
                'width': 70,
                'height': 70,
                'border-width': 2,
                'border-color': '#2980b9',
                'text-wrap': 'wrap',
                'text-max-width': '60px'
              }
            },
            // 노드 스타일 - 상담
            {
              selector: 'node[type="consultation"]',
              style: {
                'label': 'data(label)',
                'background-color': '#2ecc71',
                'text-valign': 'center',
                'text-halign': 'center',
                'color': '#fff',
                'font-size': '11px',
                'font-weight': 'bold',
                'width': 70,
                'height': 70,
                'border-width': 2,
                'border-color': '#27ae60',
                'text-wrap': 'wrap',
                'text-max-width': '60px'
              }
            },
            // 노드 스타일 - 관리
            {
              selector: 'node[type="management"]',
              style: {
                'label': 'data(label)',
                'background-color': '#f39c12',
                'text-valign': 'center',
                'text-halign': 'center',
                'color': '#fff',
                'font-size': '11px',
                'font-weight': 'bold',
                'width': 85,
                'height': 60,
                'shape': 'rectangle',
                'border-width': 2,
                'border-color': '#d68910',
                'text-wrap': 'wrap',
                'text-max-width': '75px'
              }
            },
            // 노드 스타일 - 기타
            {
              selector: 'node[type="other"]',
              style: {
                'label': 'data(label)',
                'background-color': '#9b59b6',
                'text-valign': 'center',
                'text-halign': 'center',
                'color': '#fff',
                'font-size': '11px',
                'font-weight': 'bold',
                'width': 70,
                'height': 70,
                'border-width': 2,
                'border-color': '#8e44ad',
                'text-wrap': 'wrap',
                'text-max-width': '60px'
              }
            },
            // 엣지 스타일 - 타임라인
            {
              selector: 'edge[type="timeline"]',
              style: {
                'label': 'data(label)',
                'width': 3,
                'line-color': '#34495e',
                'target-arrow-shape': 'triangle',
                'target-arrow-color': '#34495e',
                'curve-style': 'bezier',
                'font-size': '9px',
                'text-rotation': 'autorotate',
                'font-weight': 'bold'
              }
            },
            // 엣지 스타일 - 연관
            {
              selector: 'edge[type="related"]',
              style: {
                'label': 'data(label)',
                'width': 2,
                'line-color': '#95a5a6',
                'target-arrow-shape': 'triangle',
                'target-arrow-color': '#95a5a6',
                'curve-style': 'bezier',
                'font-size': '8px',
                'text-rotation': 'autorotate',
                'line-style': 'dashed'
              }
            },
            // 엣지 스타일 - 동일 날짜
            {
              selector: 'edge[type="samedate"]',
              style: {
                'label': 'data(label)',
                'width': 3,
                'line-color': '#e67e22',
                'target-arrow-shape': 'triangle',
                'target-arrow-color': '#e67e22',
                'curve-style': 'bezier',
                'font-size': '9px',
                'text-rotation': 'autorotate',
                'font-weight': 'bold'
              }
            },
            // 선택된 요소 스타일
            {
              selector: ':selected',
              style: {
                'border-width': 5,
                'border-color': '#ff6b6b'
              }
            }
          ],
          
                     layout: {
             name: 'breadthfirst',
             directed: true,
             padding: 50,
             spacingFactor: 1.5,
             avoidOverlap: true,
             fit: true,
             animate: false,
             boundingBox: undefined,
             transform: function(node, position) {
               return position;
             }
           }
        });

                 // 이벤트 핸들러
         const tooltip = document.getElementById('tooltip');
         
         // 노드 호버 이벤트 - 툴팁 표시
         cy.on('mouseover', 'node', function(evt) {
           const node = evt.target;
           const data = node.data();
           const renderedPosition = node.renderedPosition();
           
           console.log('호버된 의료 기록:', data);
           
           // 툴팁 내용 생성
           const tooltipContent = `📋 \${data.label}
📅 \${data.dateStr}
📝 \${data.content}`;
           
           tooltip.innerHTML = tooltipContent;
           tooltip.style.display = 'block';
           
           // 노드의 정확한 중심 위치에서 오른쪽 위로 약간 이동
           const cyContainer = cy.container();
           const containerRect = cyContainer.getBoundingClientRect();
           
           tooltip.style.left = (containerRect.left + renderedPosition.x + 15) + 'px';
           tooltip.style.top = (containerRect.top + renderedPosition.y - 60) + 'px';
           
           // 선택된 노드 하이라이트
           cy.elements().removeClass('highlighted');
           node.addClass('highlighted');
           node.connectedEdges().addClass('highlighted');
         });
         
         // 노드에서 마우스가 벗어날 때 툴팁 숨기기
         cy.on('mouseout', 'node', function(evt) {
           tooltip.style.display = 'none';
           
           // 하이라이트 제거
           cy.elements().removeClass('highlighted');
         });
         
         // 엣지 호버 이벤트
         cy.on('mouseover', 'edge', function(evt) {
           const edge = evt.target;
           const data = edge.data();
           const renderedMidpoint = edge.renderedMidpoint();
           
           console.log('호버된 연결:', data);
           
           // 엣지 툴팁 내용 - score가 있으면 표시
           let tooltipContent = `🔗 \${data.label}`;
           if (data.score !== null && data.score !== undefined) {
             tooltipContent += `\\n📊 유사도: \${(data.score * 100).toFixed(1)}%`;
           }
           if (data.edgeType) {
             tooltipContent += `\\n🏷️ 타입: \${data.edgeType}`;
           }
           
           tooltip.innerHTML = tooltipContent;
           tooltip.style.display = 'block';
           
           // 엣지의 중점 위치 기준으로 툴팁 배치
           const cyContainer = cy.container();
           const containerRect = cyContainer.getBoundingClientRect();
           
           tooltip.style.left = (containerRect.left + renderedMidpoint.x + 10) + 'px';
           tooltip.style.top = (containerRect.top + renderedMidpoint.y - 40) + 'px';
         });
         
         // 엣지에서 마우스가 벗어날 때 툴팁 숨기기
         cy.on('mouseout', 'edge', function(evt) {
           tooltip.style.display = 'none';
         });
         
         // 노드 클릭 이벤트 (모달 표시)
         cy.on('tap', 'node', function(evt) {
           const node = evt.target;
           const data = node.data();
           console.log('클릭된 의료 기록:', data);
           
           showModal(data);
         });
         
         // 캔버스 영역에서 마우스가 벗어날 때 툴팁 숨기기
         cy.on('mouseout', function(evt) {
           // 특정 노드나 엣지가 아닌 캔버스 자체에서 벗어날 때
           if (evt.target === cy) {
             tooltip.style.display = 'none';
             cy.elements().removeClass('highlighted');
           }
         });

                 // 그래프 중앙 정렬 강제 적용
         setTimeout(() => {
           cy.fit();
           cy.center();
         }, 100);
         
         // UI 표시
         document.getElementById('loading').style.display = 'none';
         document.getElementById('error').style.display = 'none';
         document.getElementById('cy').style.display = 'block';
         
         console.log('의료 기록 그래프 생성 완료');
        
      } catch (error) {
        console.error('그래프 생성 실패:', error);
        document.getElementById('loading').style.display = 'none';
        document.getElementById('error').style.display = 'block';
        document.getElementById('cy').style.display = 'none';
      }
    }

    // 레이아웃 변경
    function changeLayout(layoutName) {
      if (!cy) return;
      
      let layoutOptions = { name: layoutName };
      
      switch(layoutName) {
        case 'timeline':
          layoutOptions = {
            name: 'breadthfirst',
            directed: true,
            padding: 50,
            spacingFactor: 1.5,
            avoidOverlap: true,
            roots: cy.nodes().filter(node => {
              // 가장 이른 시간의 노드를 루트로 설정
              const minDate = Math.min(...medicalData.map(item => new Date(item.datetime).getTime()));
              return new Date(node.data('datetime')).getTime() === minDate;
            })
          };
          break;
        case 'circle':
          layoutOptions = {
            name: 'circle',
            fit: true,
            padding: 50,
            avoidOverlap: true,
            radius: 200
          };
          break;
        case 'grid':
          layoutOptions = {
            name: 'grid',
            fit: true,
            padding: 50,
            avoidOverlap: true,
            spacingFactor: 1.2
          };
          break;
        case 'cose':
          layoutOptions = {
            name: 'cose',
            idealEdgeLength: 150,
            nodeOverlap: 20,
            refresh: 20,
            fit: true,
            padding: 50,
            randomize: false,
            componentSpacing: 100,
            nodeRepulsion: 400000,
            edgeElasticity: 100,
            nestingFactor: 5,
            gravity: 80,
            numIter: 1000,
            initialTemp: 200,
            coolingFactor: 0.95,
            minTemp: 1.0
          };
          break;
      }
      
             const layout = cy.layout(layoutOptions);
       layout.run();
       
       // 레이아웃 완료 후 중앙 정렬
       layout.on('layoutstop', function() {
         cy.fit();
         cy.center();
       });
    }

    // 데이터 새로고침
    function refreshData() {
      if (cy) {
        cy.destroy();
      }
      loadMedicalData();
    }

    // 유사도 계산
    async function calculateSimilarity() {
      try {
        // 현재 그래프의 모든 노드 ID 수집
        const nodeIds = medicalData.map(item => item.id);
        
        console.log('유사도 계산 요청 중...', nodeIds);
        
        const response = await fetch('http://localhost:8000/graph/edges/similarity', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'Origin': 'http://localhost'
          },
          body: JSON.stringify({
            working_set: nodeIds
          })
        });
        
        if (!response.ok) {
          throw new Error(`유사도 계산 실패! status: \${response.status}`);
        }
        
        const result = await response.json();
        console.log('유사도 계산 완료:', result);
        
        // 유사도 계산 완료 후 데이터 새로고침
        refreshData();
        
      } catch (error) {
        console.error('유사도 계산 실패:', error);
        alert('유사도 계산에 실패했습니다: ' + error.message);
      }
    }

         // 모달 관련 함수들
     function showModal(data) {
       const modal = document.getElementById('detailModal');
       const modalTitle = document.getElementById('modalTitle');
       const modalDate = document.getElementById('modalDate');
       const modalContent = document.getElementById('modalContent');
       const modalId = document.getElementById('modalId');
       const modalType = document.getElementById('modalType');
       
       // 타입별 아이콘과 이름 매핑
       const typeInfo = {
         'treatment': { icon: '🏥', name: '진료', class: 'type-treatment' },
         'examination': { icon: '🔬', name: '검사', class: 'type-examination' },
         'consultation': { icon: '💬', name: '상담', class: 'type-consultation' },
         'management': { icon: '📊', name: '관리', class: 'type-management' },
         'other': { icon: '📋', name: '기타', class: 'type-other' }
       };
       
       const typeData = typeInfo[data.type] || typeInfo['other'];
       
       // 모달 내용 설정
       modalTitle.innerHTML = `\${typeData.icon} \${data.label}`;
       modalDate.textContent = data.dateStr;
       modalContent.textContent = data.content;
       modalId.textContent = data.id;
       modalType.innerHTML = `<span class="type-badge \${typeData.class}">\${typeData.icon} \${typeData.name}</span>`;
       
       // 모달 표시
       modal.style.display = 'block';
       document.body.style.overflow = 'hidden'; // 배경 스크롤 방지
     }
     
     function closeModal() {
       const modal = document.getElementById('detailModal');
       modal.style.display = 'none';
       document.body.style.overflow = 'auto'; // 스크롤 복원
     }
     
     // 모달 배경 클릭 시 닫기
     window.onclick = function(event) {
       const modal = document.getElementById('detailModal');
       if (event.target === modal) {
         closeModal();
       }
     }
     
     // ESC 키로 모달 닫기
     document.addEventListener('keydown', function(event) {
       if (event.key === 'Escape') {
         closeModal();
       }
     });

     // 페이지 로드 시 데이터 불러오기
     window.addEventListener('load', function() {
       console.log('페이지 로드 완료, 의료 데이터 로드 시작');
       loadMedicalData();
     });
  </script>
</body>
</html>
  ''';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InAppWebView(
              initialData: InAppWebViewInitialData(
                data: cytoscapeHtml,
                mimeType: 'text/html',
                encoding: 'utf-8'
              ),
              initialSettings: InAppWebViewSettings(
                javaScriptEnabled: true,
                domStorageEnabled: true,
                allowsInlineMediaPlayback: true,
                mediaPlaybackRequiresUserGesture: false,
                transparentBackground: true,
                supportZoom: true,
                builtInZoomControls: false,
                displayZoomControls: false,
                // CORS 설정
                allowsBackForwardNavigationGestures: false,
                allowFileAccessFromFileURLs: true,
                allowUniversalAccessFromFileURLs: true,
              ),
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStop: (controller, url) async {
                print('의료 기록 그래프 페이지가 로드되었습니다');
              },
              onConsoleMessage: (controller, consoleMessage) {
                print('WebView Console: ${consoleMessage.message}');
              },
            ),
          ),
        ),
      ),
    );
  }
}
