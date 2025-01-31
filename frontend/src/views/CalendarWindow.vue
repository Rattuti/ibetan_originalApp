<template>
<calendarBase />
</template>

<script>
//import moment from 'moment'
//import VueTailwindDatepicker from 'vue-tailwind-datepicker'
//import { mapGetters, mapActions } from 'vuex'
import calendarBase from '../components/calendarBase'

export default {
    components:{
        calendarBase,
    },
    data(){
        return {};
    },
    // computed: {
    //     ...mapGetters('events', ['events']),
    // },
    // methods: {
    //     ...mapActions('events', ['fetchEvents']),
    // },
    // mounted(){
    //     this.fetchEvents();
    // }
}
</script>
<style>

</style>