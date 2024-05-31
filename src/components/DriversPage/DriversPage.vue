<template>
  <div class="drivers-wrapper">
    <button class="btn" @click="back">Назад</button>
    <h2>Список водителей:</h2>
    <input type="text" id="search-input" class="my-input" placeholder="Введите имя или номер лицензии">
    <div class="table-container">
      <table id="drTable" class="table table-condensed table-striped table-bordered table-fixed-width">
        <thead>
        <tr>
          <th>ФИО</th>
          <th>Телефон</th>
          <th>Опыт вождения</th>
          <th>Количество ДТП</th>
          <th>Лицензия</th>
        </tr>
        </thead>
        <tbody>
        </tbody>
      </table>
    </div>
  </div>
  <AppFooter/>
</template>

<script>
import AppFooter from "@/components/UI/Footer.vue";
import './DriversPage.css';

export default {
  name: 'DriversPage',
  components: {AppFooter},
  data() {
    return {
      drivers: [],
      searchQuery: '',
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
        const [ response_drivers, response_accident] = await Promise.all([
          fetch('https://accident-reporter.onrender.com/policeDepartment/drivers', {
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'authorization': `${token}`,
            },
          }),
          fetch('https://accident-reporter.onrender.com/policeDepartment/accidents', {
            method: 'GET',
            headers: {
              'Content-Type': 'application/json',
              'authorization': `${token}`,
            },
          }),
        ]);

        const [ jsonDrData, jsonData] = await Promise.all([
          response_drivers.json(),
          response_accident.json(),
        ]);

        console.log(jsonData.data);
        console.log(jsonDrData.data);

        if (Array.isArray(jsonDrData.data)) {
          const accidents = jsonData.data.reduce((acc, curr) => {
            curr.participants.forEach(participant => {
              acc[participant.driver_license] = (acc[participant.driver_license] || 0) + 1;
            });
            return acc;
          }, {});

          this.drivers = jsonDrData.data.map(driver => ({
            ...driver,
            accidents: accidents[driver.driver_license] || 0,
          }));

          this.updateTable(this.drivers);
        } else {
          console.error('Ошибка: сервер не возвращает массив данных');
        }
      } catch (error) {
        console.error('Ошибка получения данных о водителях:', error);
      }
    },
    updateTable(data) {
      const table = document.getElementById('drTable');
      const tbody = table.querySelector('tbody');
      tbody.innerHTML = '';

      data.forEach(driver => {
        const row = document.createElement('tr');
        const fullNameCell = document.createElement('td');
        fullNameCell.textContent = driver.full_name;
        const phoneCell = document.createElement('td');
        phoneCell.textContent = driver.phone;
        const experienceCell = document.createElement('td');
        experienceCell.textContent = driver.driving_experience;
        const accidentsCell = document.createElement('td');
        accidentsCell.textContent = driver.accidents;
        const licenceCell = document.createElement('td');
        licenceCell.textContent = driver.driver_license;

        row.appendChild(fullNameCell);
        row.appendChild(phoneCell);
        row.appendChild(experienceCell);
        row.appendChild(accidentsCell);
        row.appendChild(licenceCell);
        tbody.appendChild(row);
      });
    },
    searchDrivers() {
      const searchQuery = this.searchQuery.toLowerCase();
      const filteredDrivers = this.drivers.filter(driver => {
        return (
            driver.full_name.toLowerCase().includes(searchQuery) ||
            driver.driver_license.toLowerCase().includes(searchQuery)
        );
      });
      this.updateTable(filteredDrivers);
    },
  },
  mounted() {
    this.getDrivers();

    const searchInput = document.getElementById('search-input');
    searchInput.addEventListener('input', () => {
      this.searchQuery = searchInput.value;
      this.searchDrivers();
    });

      // this.updateTable(sortedData);
    // }.bind(this));
  },
};
</script>


<!--добавить колонку с колличеством дтп, которая будет подсчитываться по id водителя, сколько раз он встречается в таблице из бд (accidents) 'https://accident-reporter.onrender.com/policeDepartment/accidents'-->

<!--структура данных в accident:-->