<template>
  <div class="drivers-wrapper">
    <button class="btn" @click="back">Назад</button>
    <h2>Реестр зарегистированного транспорта:</h2>
    <div class="table-container">
      <table id="drTable" class="table table-condensed table-striped table-bordered table-fixed-width">
        <thead>
        <tr>
          <th @click="showFilter('brand')">Марка</th>
          <th @click="showFilter('model')">Модель</th>
          <th @click="showFilter('body_type')">Тип</th>
          <th>Регистрационный номер</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
    <div v-if="showFilterPopup" class="filter-popup">
      <h3>Фильтр по {{ filterBy }}</h3>
      <ul>
        <li v-for="option in filterOptions" :key="option">
          <input type="checkbox" :value="option" v-model="selectedFilters">
          {{ option }}
        </li>
      </ul>
      <button @click="applyFilter()">Применить фильтр</button>
      <button @click="resetFilter()">Сбросить фильтр</button>
      <button @click="showFilterPopup = false">Закрыть</button>
    </div>
  </div>
</template>

<script>
export default {
  name: 'VehiclePage',
  data() {
    return {
      vehicles: [],
      allVehicles: [],
      showFilterPopup: false,
      filterBy: '',
      filterOptions: [],
      selectedFilters: [],
    };
  },
  methods: {
    back() {
      this.$router.push('/admin');
    },
    async getDrivers() {
      try {
        const token = localStorage.getItem('token');
        console.log(token);
        const request = {
          method: 'GET',
          headers: {
            'Content-Type': 'application/json',
            'authorization': `${token}`,
          },
        };
        const response = await fetch('https://accident-reporter.onrender.com/policeDepartment/vehicles', request);
        const jsonResponse = await response.json();
        console.log(jsonResponse.data);
        if (Array.isArray(jsonResponse.data)) {
          this.vehicles = jsonResponse.data;
          this.allVehicles = [...jsonResponse.data];
          this.updateTable(this.vehicles);
        } else {
          console.error('Ошибка: сервер не возвращает массив данных');
        }
      } catch (error) {
        console.error('Ошибка получения данных о транспорте:', error);
      }
    },
    updateTable(data) {
      const table = document.getElementById('drTable');
      const tbody = table.querySelector('tbody');
      tbody.innerHTML = '';

      data.forEach(vehicle => {
        const row = document.createElement('tr');
        const marckCell = document.createElement('td');
        marckCell.textContent = vehicle.brand;
        const modelCell = document.createElement('td');
        modelCell.textContent = vehicle.model;
        const typeCell = document.createElement('td');
        typeCell.textContent = vehicle.body_type;
        const numbCell = document.createElement('td');
        numbCell.textContent = vehicle.reg_number;

        row.appendChild(marckCell);
        row.appendChild(modelCell);
        row.appendChild(typeCell);
        row.appendChild(numbCell);
        tbody.appendChild(row);
      });
    },
    showFilter(by) {
      this.filterBy = by;
      this.filterOptions = [...new Set(this.vehicles.map(vehicle => vehicle[by]))];
      this.showFilterPopup = true;
    },
    applyFilter() {
      if (this.selectedFilters.length > 0) {
        this.vehicles = this.allVehicles.filter(vehicle => {
          return this.selectedFilters.includes(vehicle[this.filterBy]);
        });
        this.updateTable(this.vehicles);
      }
      this.showFilterPopup = false;
    },
    resetFilter() {
      this.vehicles = [...this.allVehicles];
      this.updateTable(this.vehicles);
      this.selectedFilters = [];
      this.showFilterPopup = false;
    },
  },
  mounted() {
    this.getDrivers();
  },
};
</script>

<style scoped>
.filter-popup {
  position: absolute;
  width: 200px;
  background-color: #fff;
  padding: 20px;
  border: 1px solid #ddd;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
}

.filter-popup ul{
  list-style: none;
  text-align: left;

}
</style>

