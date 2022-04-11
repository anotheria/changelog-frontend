<template lang="html">

  <div class="filter">
    <div class="filter__inner">
      <div class="filter__item">
        <div class="filter__item-title">
          Date
        </div>
        <Datepicker
          v-model="date"
          @update:modelValue="updateDate"
          range
          :format="'dd/MM/yyyy'"
          :enableTimePicker="false"></Datepicker>
      </div>

      <div
        v-for="(filter, index) in filters"
        :key="`filter-group-${index}`"
        class="filter__item"
      >
        <div class="filter__item-title">
          {{ filter.filterName }}
        </div>
        <div class="filter__check">
          <label
            v-for="(filterValue, index) in filter.filterValues"
            :key="`filter-item-${index}`"
            class="filter__check-label"
          >
            <input
              class="filter__checkbox"
              type="checkbox"
              v-model="filterValue.isActiveFilter"
            />
            <span class="filter__checkbox-style"></span>
            {{ filterValue.filterValueName }}
          </label>
        </div>
      </div>
    </div>
  </div>

</template>

<script lang="js">
  import Datepicker from '@vuepic/vue-datepicker';
  import '@vuepic/vue-datepicker/dist/main.css'

  export default  {
    name: 'changelog-filters',
    components: {
      Datepicker
    },
    props: {
      filters: {
        type: Array,
        required: true
      },
    },

    data () {
      return {
        date: null
      }
    },

    methods: {
      normalizeDate() {
        if (this.date && !this.date[1]) {
          this.date[1] = this.date[0];
        }
        if (this.date) {
          this.date[0] = new Date(this.date[0].setHours(0, 0, 0, 0));
          this.date[1] = new Date(this.date[1].setHours(23, 59, 59, 999));
        }
      },

      updateDate(){
        this.normalizeDate();

        this.$emit("updateDate", this.date);
      }
    },
    computed: {

    }
}


</script>

<style scoped lang="scss">
  .changelog-filters {

  }
</style>
