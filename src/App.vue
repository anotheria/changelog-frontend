<template>
  <div class="wrapper">
    <changelog-header
      v-model:loader="loaderList"
      @doSearch="doSearch"
    ></changelog-header>

    <main class="main">
      <div class="container">
        <div class="main__inner">
          <div class="main__col">
            <changelog-filters
              :filters="filters"
              :loader="loaderFilters"
              @dateFilter="filterDateRange"
              @activeFilters="filterCheckboxGroup"
            ></changelog-filters>
          </div>

          <div class="main__col">
            <changelog-list
              :currentPage="page"
              :list="changelogList"
              :loader="loaderList"
              :filtersList="filtersList"
              :pages="pages"
              @updateList="getChangelogList"
              @changePage="changePage"
            ></changelog-list>
          </div>
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
        filtersList: {
          tags: [],
          type: []
        },
        loaderList: false,
        loaderFilters: false,
        showModal: false,
        currentDate: null,
        formData: {
          id: null,
          timestamp: null,
          author: '',
          message: '',
          reason: '',
          tags: [],
          type: null
        },
        paging: {},
        pages: 1,
        page: 1,
        configList: {
          paging: {
            page: 0,
            itemsOnPage: 10
          },
          sort: [
            {
              field: "TIMESTAMP",
              order: "DESC"
            }
          ]
        },
      };
    },

    methods: {
      updateAppData() {
        this.getChangelogList();
        this.getFilters();
      },

      getChangelogList() {
        this.loaderList = true;
        this.loaderFilters = true;
        axios
          .post("api/changelog/list/", this.configList)
          .then((response) => {
            let data = response.data.results.data;
            this.changelogList = data.items;
            this.pages = Math.ceil(data.paging.items / data.paging.itemsOnPage);
            this.loaderList = false;
            this.loaderFilters = false;
          })
          .catch((error) => console.log(error));
      },

      getFilters() {
        axios
          .get("api/changelog/types/")
          .then((response) => {
            this.filtersList.type = response.data.results.data;

            this.filters.type.filterName = 'Type'
            this.filters.type.filterValues = response.data.results.data.map(item => {
              return {filterValueName: item, isActiveFilter: false};
            });

          })
          .catch((error) => console.log(error));

        axios
          .get("api/changelog/tags/")
          .then((response) => {
            this.filtersList.tags = response.data.results.data;

            this.filters.tags.filterName = 'Tags'
            this.filters.tags.filterValues = response.data.results.data.map(item => {
              return {filterValueName: item, isActiveFilter: false};
            });

          })
          .catch((error) => console.log(error));
      },

      changePage(page) {
        this.page = page;
        this.configList.paging.page = page - 1;
        this.getChangelogList();
      },

      filterDateRange(dateRange) {
        if (dateRange.length) {
          this.configList.timeRange = {
            start: dateRange[0],
            end: dateRange[1]
          };
        } else {
          delete this.configList.timeRange;
        }
        this.configList.paging.page = 0;
        this.changePage(1);
      },

      filterCheckboxGroup(filters) {
        this.configList.groupFilters = [
          {
            field: "TAG",
            value: filters.tags
          },
          {
            field: "TYPE",
            value: filters.type
          }
        ];

        this.configList.paging.page = 0;
        this.changePage(1);
      },

      doSearch(value) {
        this.configList.searchTerm = value.trim();
        this.configList.paging.page = 0;
        this.changePage(1);
      }
    },

    mounted() {
      this.updateAppData()
    },

    computed: {}
  };
</script>

<style lang="scss">
  .dp__main {
    position: relative;
  }
</style>
