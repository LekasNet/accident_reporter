<template>
  <!--  <router-link class="btn-logout" to="/admin">Назад</router-link>-->
  <button class="btn" @click="back">Назад</button>
  <div class="card-list">
    <DTPCard class="card-item"
             v-for="(item, index) in cards"
             :key="index"
             :title="item.title"
             :date="item.date"
             :GosNumb="item.GosNumb"
             :Data="item.Data"
             :description="item.description"
             :gosNumbAdditionalInfo="item.gosNumbAdditionalInfo"
             :dataAdditionalInfo="item.dataAdditionalInfo"
    />
  </div>
</template>


<script>
  import DTPCard from "@/components/UI/DTPCard/Card.vue";
  import './DtpPage.css'
  // import vehicle from "@/components/VehiclePage/Vehicle.vue";
  export default {
    name: "DtpPage",
    components: {
      DTPCard
    },
    data() {
      return {
        cards: [],
        cards2: []
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
          const request_accident = {
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'authorization': `${token}`,
            },
          };
          const response_accident = await fetch('https://accident-reporter.onrender.com/policeDepartment/accidents', request_accident);
          const jsonData = await response_accident.json();
          console.log(jsonData.data);

          const request_vehicles = {
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'authorization': `${token}`,
            },
          };
          const response_vehicles = await fetch('https://accident-reporter.onrender.com/policeDepartment/vehicles', request_vehicles);
          const jsonVehData = await response_vehicles.json();
          console.log(jsonVehData.data);

          if (Array.isArray(jsonData.data) && Array.isArray(jsonVehData.data)) {
            this.cards = jsonData.data;
            this.cards = jsonData.data.map(item => ({
              title: `ДТП №${item.report_number}`,
              date: item.date,
              GosNumb: this.cards2.find(veh => veh.id === item.participants.vehicle_id
              )?.reg_number,
              Data: item.location,
              description: item.accident_cause,
              gosNumbAdditionalInfo: item.participants.driver_id,
              dataAdditionalInfo: item.accident_type,
            }));
          } else {
            console.error('Ошибка: сервер не возвращает массив данных');
          }
        } catch (error) {
          console.error('Ошибка получения данных о ДТП:', error);
        }
      }
    },

    mounted() {
      this.getDTPData();
    }
  }
</script>

