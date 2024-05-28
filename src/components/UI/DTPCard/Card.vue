<script>
  import './Card.css'
  export default {
    name: "DTPCard",
    props: {
      title: {
        type: String,
        required: true
      },
      date: {
        type: Date,
        required: true
      },
      GosNumb: {
        type: Number,
        required: true
      },
      Data: {
        type: String,
        required: true
      },
      description: {
        type: String,
        required: true
      },
      gosNumbAdditionalInfo: {
        type: String,
        required: true
      },
      dataAdditionalInfo: {
        type: String,
        required: true
      },
    },
    data() {
      // return {
      //   showGosNumbInfo: false,
      //   showDataInfo: false,
      // };
      return {
        activeInfo: null,
      };
    },
    methods: {
      showInfo(infoType) {
        if (this.activeInfo === infoType) {
          this.activeInfo = null;
        } else {
          this.activeInfo = infoType;
        }
      },
    },
  };
</script>

<template>
  <div class="card">
    <h2>{{title}}</h2>
    <div class="cars-description">
      <div class="card-info">
        <p>Дата:</p>
        <p class="cars-description-item">{{date}}</p>
      </div>
      <div class="card-info" @click="showInfo('gos-numb')">
        <p>Гос. номер:</p>
        <p class="cars-description-item">{{GosNumb}}</p>
        <div class="additional-info" v-if="activeInfo === 'gos-numb'">
          <p>Дополнительная информация:</p>
          <p>{{gosNumbAdditionalInfo}}</p>
        </div>
      </div>
      <div class="card-info" @click="showInfo('data')">
        <p>Инфа:</p>
        <p class="cars-description-item">{{Data}}</p>
        <div class="additional-info" v-if="activeInfo === 'data'">
          <p>Дополнительная информация:</p>
          <p>{{dataAdditionalInfo}}</p>
        </div>
      </div>
      <div class="card-info" @click="showInfo('description')">
        <p>Описание:</p>
        <p class="cars-description-item">подробнее..</p>
        <div class="additional-info" v-if="activeInfo === 'description'">
          <p>Дополнительная информация:</p>
          <p>{{description}}</p>
        </div>
      </div>
    </div>
  </div>
</template>