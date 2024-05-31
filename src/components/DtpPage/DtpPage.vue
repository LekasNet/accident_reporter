<template>
  <button class="btn" @click="back">Назад</button>
  <div class="card-list">
    <DTPCard class="card-item"
             v-for="(item, index) in cards"
             :key="index"
             :id="item.id"
             :title="item.title"
             :date="item.date"
             :GosNumb="item.GosNumb"
             :Data="item.Data"
             :description="item.description"
             :gosNumbAdditionalInfo="item.gosNumbAdditionalInfo"
             :dataAdditionalInfo="item.dataAdditionalInfo"
             @click="showDetails(item)"
    />
  </div>

  <div v-if="selectedCard" class="details-popup">
    <button @click="selectedCard = null" class="close-btn">&times;</button>
    <div class="header">
      <h2>{{ selectedCard.title }}</h2>
    </div>
    <div class="details">
      <p><span>Дата:</span> <br> {{ selectedCard.date }}</p>
      <p><span>Участники ДТП:</span> <br>
        <ul>
          <li v-for="(driver, index) in selectedCard.drivers" :key="index">{{ driver.fullName }}</li>
        </ul>
      </p>
      <p><span>Гос. номер(а):</span> <br>
        <ul>
          <li v-for="gosNumb in selectedCard.GosNumb.split(' ')" :key="gosNumb">{{ gosNumb }}</li>
        </ul>
      </p>
      <p><span>Адресс:</span> <br> {{ selectedCard.Data }}</p>
      <p><span>Причина:</span> <br> {{ selectedCard.description }}</p>
    </div>
  </div>
  <AppFooter/>
</template>


<script>
  import AppFooter from "@/components/UI/Footer.vue";
  import DTPCard from "@/components/UI/DTPCard/Card.vue";
  import './DtpPage.css'

  export default {
    name: "DtpPage",
    components: {
      AppFooter,
      DTPCard
    },
    data() {
      return {
        cards: [],
        selectedCard: null,
        // cards2: []
      }
    },

    methods: {
      back() {
        this.$router.push('/admin');
      },

      async getDTPData() {
        try {
          const token = localStorage.getItem('token');
          console.log(token);

          const [response_accident, response_vehicles, response_drivers] = await Promise.all([
            fetch('https://accident-reporter.onrender.com/policeDepartment/accidents', {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
                'authorization': `${token}`,
              },
            }),
            fetch('https://accident-reporter.onrender.com/policeDepartment/vehicles', {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
                'authorization': `${token}`,
              },
            }),
            fetch('https://accident-reporter.onrender.com/policeDepartment/drivers', {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
                'authorization': `${token}`,
              },
            }),
          ]);

          const [jsonData, jsonVehData, jsonDrData] = await Promise.all([
            response_accident.json(),
            response_vehicles.json(),
            response_drivers.json()
          ]);

          console.log(jsonData.data);
          console.log(jsonVehData.data);
          console.log(jsonDrData.data);

          if (Array.isArray(jsonData.data) && Array.isArray(jsonVehData.data) && Array.isArray(jsonDrData.data)) {
            this.cards = jsonData.data;
            console.log(this.cards)
            this.cards = jsonData.data.map(item => ({
              title: `ДТП №${item.id}`,
              date: item.date.replace('T', ' ').slice(0, 19),
              // drivers: item.participants.map(participant => {
              //   return jsonDrData.data.find(dr => dr.driver_license === participant.driver_license)?.full_name;
              // }).filter(regNumber => regNumber !== undefined).join(' '),
              drivers: item.participants.map(participant => {
                const driver = jsonDrData.data.find(dr => dr.driver_license === participant.driver_license);
                return {
                  fullName: driver.full_name,
                  // Add other driver information here
                };
              }),
              GosNumb: item.participants.map(participant => {
                return jsonVehData.data.find(veh => veh.reg_number === participant.vehicle_reg_number)?.reg_number;
              }).filter(regNumber => regNumber !== undefined).join(' '),
              Data: item.location,
              description: item.accident_cause,
              gosNumbAdditionalInfo: item.participants.driver_id,
              dataAdditionalInfo: item.accident_type,
            }));
            console.log(this.cards[0])


          } else {
            console.error('Ошибка: сервер не возвращает массив данных');
          }

        } catch (error) {
          console.error('Ошибка получения данных о ДТП:', error);
        }
      },
      showDetails(card) {
        this.selectedCard = card;
      },
    },

    mounted() {
      this.getDTPData();
    }
  }
</script>

<style>
.details-popup {
  position: fixed;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  background-color: #fff;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
  width: 300px;
  text-align: left;
}


  .header {
    display: flex;
    justify-content: center;
  }

.close-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  background-color: transparent;
  border: none;
  font-size: 18px;
  cursor: pointer;
}

.close-btn:hover {
  color: #ccc;
}

  .details {
    margin-top: 20px;
  }

  .details p {
    margin-bottom: 10px;
  }

  .details span {
    font-weight: bold;
  }
.details ul {
  list-style: none;
  padding: 0;
  margin: 0;
}

.details li {
  margin-bottom: 5px;
}

</style>

