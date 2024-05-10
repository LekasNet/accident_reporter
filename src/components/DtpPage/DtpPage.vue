<script>
  import DTPCard from "@/components/UI/DTPCard/Card.vue";
  import './DtpPage.css'
  export default {
    name: "DtpPage",
    components: {
      DTPCard
    },
    methods:{
      back(){
        this.$router.push('/admin');
      },
    },
    data() {
      return {
        cards : [
          { title: 'Card 1', date:'12-12-22 12:12:12', GosNumb:'12321', Data:'lj/kh.sajkhgfjdh jhlgkfjdh jhgdu cfghn jhglfkyj', description: 'Lorem ipsum dolor sit amet', gosNumbAdditionalInfo: 'sdfghjkl', dataAdditionalInfo:'dfghjkl fgvhbjnk' },
          { title: 'Card 1', date:'12-12-22 12:12:12', GosNumb:'12321', Data:'lj/kh.sajkhgfjdh jhlgkfjdh jhgdu cfghn jhglfkyj', description: 'Lorem ipsum dolor sit amet' },
          { title: 'Card 1', date:'12-12-22 12:12:12', GosNumb:'12321', Data:'lj/kh.sajkhgfjdh jhlgkfjdh jhgdu cfghn jhglfkyj', description: 'Lorem ipsum dolor sit amet' },
          { title: 'Card 1', date:'12-12-22 12:12:12', GosNumb:'12321', Data:'lj/kh.sajkhgfjdh jhlgkfjdh jhgdu cfghn jhglfkyj', description: 'Lorem ipsum dolor sit amet' },
          { title: 'Card 2', description: 'Consectetur adipiscing elit' },
          { title: 'Card 3', description: 'Sed do eiusmod tempor incididunt' },
          { title: 'Card 3', description: 'Sed do eiusmod tempor incididunt' }
        ]
      }
    }
  }
</script>

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