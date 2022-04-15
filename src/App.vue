<template>
  <div class="wrapper">

    <changelog-header v-model:loader="loaderList" v-model:changelog-list="changelogList"></changelog-header>

    <main class="main">
      <div class="container">
        <div class="main__inner">
          <changelog-filters
            class="main__col"
            :filters="filters"
            :loader="loaderFilters"
            v-model:date-filter="dateFilter"
            v-model:active-filters="activeFilters"
          ></changelog-filters>

          <changelog-list
            class="main__col"
            :list="filteredChangelogList"
            :loader="loaderList"
          ></changelog-list>
        </div>
      </div>
    </main>
  </div>
</template>

<script>
import axios from "axios";
import ChangelogHeader from "@/components/ChangelogHeader";
import ChangelogList from "@/components/ChangelogList";
import ChangelogFilters from "@/components/ChangelogFilters";

export default {
  name: "App",
  components: {
    ChangelogHeader,
    ChangelogFilters,
    ChangelogList,
  },
  data: () => {
    return {
      changelogList: [],
      dateFilter: [],
      filters: {
        type: {
          filterName: "Type",
          filterValues: [],
        },
        tags: {
          filterName: "Tags",
          filterValues: [],
        }
      },
      activeFilters: null,
      loaderList: false,
      loaderFilters: false
    };
  },

  methods: {
    async getChangelogList() {
      this.loaderList = true;
      this.loaderFilters = true;
      axios
        .get("api/changelog/entries/")
        .then((response) => {
          this.changelogList = response.data.results.entries;
          this.getFilters();
          this.loaderList = false;
          this.loaderFilters = false;
        })
        .catch((error) => console.log(`getChangelogList() error : ${error}`));
    },

    getFilters() {
      this.changelogList.forEach(item => {
        if (!this.filters.type.filterValues.find(filterValue => filterValue.filterValueName === item.type)) {
          this.filters.type.filterValues.push({filterValueName: item.type, isActiveFilter: false});
        }

        item.tags.forEach(tag => {
          if (!this.filters.tags.filterValues.find(filterValue => filterValue.filterValueName === tag)) {
            this.filters.tags.filterValues.push({filterValueName: tag, isActiveFilter: false});
          }
        })
      })
    }

  },

  computed: {
    filteredChangelogList() {
      let filteredList = [];

      if (this.changelogList?.length && this.activeFilters) {
        filteredList = this.changelogList.filter(
          (changelogItem) =>
            (!this.activeFilters.tags.length ||
              this.activeFilters.tags.filter(tag => {
                return changelogItem.tags.some(logItemTag => logItemTag === tag)
              }).length) &&
            (!this.activeFilters.type.length ||
              this.activeFilters.type.includes(changelogItem.type)) &&
            (!this.dateFilter.length ||
              (this.dateFilter[0] <= +changelogItem.timestamp &&
                this.dateFilter[1] >= +changelogItem.timestamp))
        );
      }

      return filteredList;
    }
  },

  mounted() {
    this.getChangelogList();
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
