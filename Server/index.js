const fs = require("fs");
const express = require("express");
const bodyParser = require("body-parser");
const cors = require("cors");
const mysql = require("mysql");

const app = express();
const port = process.env.PORT || 5500;

// JSON 데이터를 읽어와 MySQL 연결 설정
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST"],
    credentials: true,
  })
);

const data = fs.readFileSync("./database.json");
const conf = JSON.parse(data);

const db = mysql.createConnection({
  host: conf.host,
  user: conf.user,
  password: conf.password,
  port: conf.port,
  database: conf.database,
});
db.connect();

// 패키지 관련 API 라우팅
app.get("/api/package", (req, res) => {
  // 랜덤 순서로 패키지 목록을 가져오는 쿼리
  db.query(
    "SELECT * FROM TripPlanner.package ORDER BY RAND()",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/package/wish", (req, res) => {
  // 위시리스트 패키지 목록을 가져오는 쿼리
  db.query(
    "SELECT * FROM TripPlanner.package WHERE wish = 1",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/package/wish/update/:wish/:id", (req, res) => {
  // 패키지를 위시리스트에 업데이트하는 쿼리
  db.query(
    `UPDATE TripPlanner.package SET wish = ${req.params.wish} WHERE id = ${req.params.id}`,
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

// 관광지 관련 API 라우팅
app.get("/api/tourist_spot", (req, res) => {
  // 랜덤 순서로 관광지 목록을 가져오는 쿼리
  db.query(
    "SELECT * FROM TripPlanner.tourist_spot ORDER BY RAND()",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/tourist_spot/wish", (req, res) => {
  // 위시리스트 관광지 목록을 가져오는 쿼리
  db.query(
    "SELECT * FROM TripPlanner.tourist_spot WHERE wish = 1",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/tourist_spot/identification/:id", (req, res) => {
  // id값을 통해 관광지의 상세 정보를 가져오는 쿼리
  db.query(
    `SELECT * FROM TripPlanner.tourist_spot WHERE id = ${req.params.id}`,
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/tourist_spot/wish/update/:wish/:id", (req, res) => {
  // 관광지를 위시리스트에 업데이트하는 쿼리
  db.query(
    `UPDATE TripPlanner.tourist_spot SET wish = ${req.params.wish} WHERE id = ${req.params.id}`,
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

// 숙소 관련 API 라우팅
app.get("/api/accommodation", (req, res) => {
  // 랜덤 순서로 숙소 목록을 가져오는 쿼리
  db.query(
    "SELECT * FROM TripPlanner.accommodation ORDER BY RAND()",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/accommodation/wish", (req, res) => {
  // 위시리스트 숙소 목록을 가져오는 쿼리
  db.query(
    "SELECT * FROM TripPlanner.accommodation WHERE wish = 1",
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/accommodation/wish/update/:wish/:id", (req, res) => {
  // 위시리스트에 숙소를 업데이트하는 쿼리
  db.query(
    `UPDATE TripPlanner.accommodation SET wish = ${req.params.wish} WHERE id = ${req.params.id}`,
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

app.get("/api/accommodation/identification/:id", (req, res) => {
  // id값을 통해 숙소의 상세 정보를 가져오는 쿼리
  db.query(
    `SELECT * FROM TripPlanner.accommodation WHERE id = ${req.params.id}`,
    (err, rows, fields) => {
      res.send({ results: rows });
    }
  );
});

// 일정 관련 API 라우팅
app.get("/api/plan", (req, res) => {
  // 일정 목록을 가져오는 쿼리
  db.query("SELECT * FROM TripPlanner.plan", (err, rows, fields) => {
    res.send({ results: rows });
  });
});

// 새 일정 생성
app.get("/api/plan/insert/:name/:accommodation/:spot_list", (req, res) => {
  let dict = [];
  const spotArray = req.params.spot_list.split("-");

  // 출발 지점인 숙소 정보를 가져오는 쿼리
  db.query(
    `SELECT id, latitude, longitude FROM TripPlanner.accommodation WHERE id = ${req.params.accommodation}`,
    (err, rows, fields) => {
      dict.push({
        id: rows[0].id,
        lat: rows[0].latitude,
        lon: rows[0].longitude,
      });

      // 관광지 정보를 가져오는 쿼리
      for (let i = 0; i < spotArray.length - 1; i++) {
        db.query(
          `SELECT id, latitude, longitude FROM TripPlanner.tourist_spot WHERE id = ${spotArray[i]}`,
          (err, rows, fields) => {
            // 관광지 리스트 문자열을 dict 배열로 변형
            dict.push({
              id: rows[0].id,
              lat: rows[0].latitude,
              lon: rows[0].longitude,
            });

            // 모든 정보를 기반으로 TSP 알고리즘을 통해 최적의 순서로 재배치
            if (i == spotArray.length - 2) {
              const startPoint = dict[0];
              const remainingPoints = dict.slice(1);
              const reorderedDict = nearestNeighbor(
                startPoint,
                remainingPoints
              );
              const reorderedSpotList =
                reorderedDict
                  .slice(1)
                  .map((item) => item.id)
                  .join("-") + "-";

              const params = [
                req.params.name,
                req.params.accommodation,
                reorderedSpotList,
              ];

              // 최종적으로 계획을 저장하는 쿼리
              db.query(
                `INSERT INTO TripPlanner.plan (name, accommodation, spot_list) VALUES (?, ?, ?)`,
                params,
                (err, rows, fields) => {
                  res.send({ results: rows });
                }
              );
            }
          }
        );
      }
    }
  );

  // Haversine formula : 경도와 위도가 주어진 두 지점 사이의 대원 거리를 계산
  function haversineDistance(lat1, lon1, lat2, lon2) {
    // 지구 반경 상수 (단위: km)
    const earthRadius = 6371;

    // 각도를 라디안으로 변환
    const dLat = toRadians(lat2 - lat1);
    const dLon = toRadians(lon2 - lon1);

    // Haversine 공식 계산
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(toRadians(lat1)) *
        Math.cos(toRadians(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    // 대원 거리 계산 및 소수점 둘째 자리까지 반환
    const distance = (earthRadius * c).toFixed(2);

    return distance;
  }

  // 각도를 라디안으로 변환하는 함수
  function toRadians(degrees) {
    return (degrees * Math.PI) / 180;
  }

  // TSP (Nearest Neighbor Algorithm)
  // 최근접 이웃 알고리즘을 사용한 외판원 문제 해결 함수
  function nearestNeighbor(start, points) {
    // 결과 배열 초기화 및 남은 지점 배열 생성
    const result = [start];
    const remainingPoints = [...points];

    while (remainingPoints.length > 0) {
      let nearestIndex = 0;
      let nearestDistance = haversineDistance(
        start.lat,
        start.lon,
        remainingPoints[0].lat,
        remainingPoints[0].lon
      );

      // 최근접 지점 찾기
      for (let i = 1; i < remainingPoints.length; i++) {
        const distance = haversineDistance(
          start.lat,
          start.lon,
          remainingPoints[i].lat,
          remainingPoints[i].lon
        );
        if (distance < nearestDistance) {
          nearestIndex = i;
          nearestDistance = distance;
        }
      }

      // 최근접 이웃을 다음 출발점으로 설정하고 결과에 추가
      start = remainingPoints[nearestIndex];
      result.push(start);
      remainingPoints.splice(nearestIndex, 1);
    }
    return result;
  }
});

app.listen(port, () => console.log(`Listening on port ${port}`));
