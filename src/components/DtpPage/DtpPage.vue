<template>
  <!--  <router-link class="btn-logout" to="/admin">Назад</router-link>-->
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
    <h2>{{ selectedCard.title }}</h2>
    <p>Дата: {{ selectedCard.date }}</p>
    <p>Гос. номер: {{ selectedCard.GosNumb }}</p>
    <p>Место: {{ selectedCard.Data }}</p>
    <p>Причина: {{ selectedCard.description }}</p>
    <p>Дополнительная информация о гос. номере: {{ selectedCard.gosNumbAdditionalInfo }}</p>
    <p>Дополнительная информация о дате: {{ selectedCard.dataAdditionalInfo }}</p>
    <button @click="selectedCard = null">Закрыть</button>
  </div>
</template>


<script>
  import DTPCard from "@/components/UI/DTPCard/Card.vue";
  import './DtpPage.css'

  export default {
    name: "DtpPage",
    components: {
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

          const [response_accident, response_vehicles] = await Promise.all([
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
          ]);

          const [jsonData, jsonVehData] = await Promise.all([
            response_accident.json(),
            response_vehicles.json(),
          ]);

          console.log(jsonData.data);
          console.log(jsonVehData.data);

          if (Array.isArray(jsonData.data) && Array.isArray(jsonVehData.data)) {
            // this.cards2 = jsonVehData.data;
            this.cards = jsonData.data;
            console.log(this.cards[0])
            this.cards = jsonData.data.map(item => ({
              id: item.id,
              title: `ДТП №${item.report_number}`,
              date: item.date.replace('T', ' ').slice(0, 19),
              GosNumb: item.participants.map(participant => {
                return jsonVehData.data.find(veh => veh.id === participant.vehicle_id)?.reg_number;
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
  }
</style>

