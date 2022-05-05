<template lang="html">
  <div class="filter">
    <div v-if="!loader" class="filter__inner">
      <div class="filter__item">
        <div class="filter__item-title">Date</div>
        <Datepicker
          v-model="date"
          @update:modelValue="$emit('dateFilter', getDateRange())"
          range
          :format="'dd/MM/yyyy'"
          :enableTimePicker="false"
        ></Datepicker>
      </div>

      <div
        v-for="(filter, key) in filters"
        :key="key"
        class="filter__item"
      >
        <div class="filter__item-title">
          {{ filter.filterName }}
        </div>
        <div class="filter__check">
          <label
            v-for="filterValue in filter.filterValues"
            :key="filterValue.filterValueName"
            class="filter__check-label"
          >
            <input
              class="filter__checkbox"
              type="checkbox"
              v-model="filterValue.isActiveFilter"
              @change="$emit('activeFilters', getActiveFilters())"
            />
            <span class="filter__checkbox-style"></span>
            {{ filterValue.filterValueName }}
          </label>
        </div>
      </div>
    </div>
    <div v-else class="loader">Loading...</div>
  </div>
</template>

<script lang="js">
  import Datepicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css'

  export default {
    name: 'changelog-filters',
    components: {
      Datepicker
    },
    props: {
      filters: {
        type: Object,
        required: true
      },
      // activeFilters: {
      //   required: true,
      // },
      // dateFilter:{
      //   required: true
      // },
      loader: {
        type: Boolean,
      }
    },

    data() {
      return {
        date: null
      }
    },

    methods: {
      getDateRange() {
        let dateRange = [];
        if (this.date && !this.date[1]) {
          dateRange = this.date;
          dateRange[1] = this.date[0];
        }
        if (this.date) {
          dateRange[0] = new Date(this.date[0].setHours(0, 0, 0, 0)).getTime();
          dateRange[1] = new Date(this.date[1].setHours(23, 59, 59, 999)).getTime();
        }
        return dateRange;
      },

      getActiveFilters() {
        let activeFiltersList = {};
        for (let filter in this.filters) {
          activeFiltersList[filter] = [];
          this.filters[filter].filterValues.forEach((filterValue) => {
            if (filterValue.isActiveFilter) {
              activeFiltersList[filter].push(filterValue.filterValueName);
            }
          });
        }
        return activeFiltersList;
      },
    },
    computed: {},

    mounted() {
      this.$emit('update:activeFilters', this.getActiveFilters())
    }
  }
</script>

<style scoped lang="scss">
  .dp__main {
    margin-bottom: 25px;
  }

  .dp__input {
    font-size: 14px;
    min-width: 225px;
  }
</style>
