<template>
  <div class="wrapper">
    <header class="header">
      <div class="container">
        <div class="header__inner">
          <div class="header__logo">Anotheria changelog</div>
          <form class="header__search search">
            <input class="search__input" type="text" placeholder="Search" />
            <button class="search__submit"></button>
          </form>
        </div>
      </div>
    </header>

    <main class="main">
      <div class="container">
        <div class="main__inner">

          <changelog-filters
            class="main__col"
            :filters="filters"
            @update-date="updateDate($event)"
          ></changelog-filters>

          <changelog-list :list="filteredChangelogList"></changelog-list>

        </div>
      </div>
    </main>
  </div>
</template>

<script>
  import ChangelogList from "@/components/ChangelogList";
  import ChangelogFilters from "@/components/ChangelogFilters";
  import axios from 'axios'

  export default {
    name: "App",
    components: {
      ChangelogFilters,
      ChangelogList
    },
    data: () => {
      return {
        changelogList: {},
        date: null,
        filters: [
          {
            filterName: "type",
            filterValues: [
              {
                filterValueName: "crash",
                isActiveFilter: false
              },
              {
                filterValueName: "change",
                isActiveFilter: false
              },
            ]
          },
          {
            filterName: "tags",
            filterValues: [
              {
                filterValueName: "cron",
                isActiveFilter: false
              },
              {
                filterValueName: "tcl",
                isActiveFilter: false
              },
            ]
          }
        ],
      };
    },

    methods: {
      async fetchList() {
        axios
          .get('./mockup.json')
          .then(response => (this.changelogList = response.data))
          .catch(error => console.log(`fetchList() error : ${error}`));
      },

    updateDate(newDate){
      this.date = newDate;
    }
  },

  computed: {
    filteredChangelogList() {
      let filteredList = [];
      if (this.changelogList.data?.length) {
        filteredList = this.changelogList.data.filter(
          (changelogItem) =>
            (!this.activeFilters.tags.length ||
              this.activeFilters.tags.includes(changelogItem.tags)) &&
            (!this.activeFilters.type.length ||
              this.activeFilters.type.includes(changelogItem.type)) &&
            (!this.date ||
              (this.date[0] <= +changelogItem.date &&
                this.date[1] >= +changelogItem.date))
        );
      }
      return filteredList;
    },

    activeFilters() {
      let activeFilters = {};
      this.filters.forEach((filter) => {
        activeFilters[filter.filterName] = [];

        filter.filterValues.forEach((filterValue) => {
          if (filterValue.isActiveFilter) {
            activeFilters[filter.filterName].push(filterValue.filterValueName);
          }
        });
      });

      return activeFilters;
    },
  },

  mounted() {
    this.fetchList();
  },
};
</script>

<style lang="scss">
.dp__main {
  margin-bottom: 25px;
}

.dp__input {
  font-size: 14px;
  min-width: 225px;
}
</style>
