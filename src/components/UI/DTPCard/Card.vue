<script>
  import './Card.css'
  export default {
    name: "DTPCard",
    props: {
      id: {
        type: Number,
        required: true
      },
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
      return {
        activeInfo: null,
        localStatus: this.status
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
        <p class="card-info-text">Дата:</p>
        <p class="cars-description-item">{{date}}</p>
      </div>
<!--      <div class="card-info" @click="showInfo('gos-numb')">-->
<!--        <p class="card-info-text">Гос. номер:</p>-->
<!--        <p class="cars-description-item">{{GosNumb}}</p>-->
<!--      </div>-->
      <div class="card-info" @click="showInfo('data')">
        <p class="card-info-text">Описание:</p>
        <p class="cars-description-item">{{dataAdditionalInfo}}</p>
      </div>
<!--      <div class="card-info" @click="showInfo('description')">-->
<!--        <p class="card-info-text">Описание:</p>-->
<!--        <p class="cars-description-item">подробнее..</p>-->
<!--      </div>-->
    </div>
  </div>
</template>
