
import 'package:ajoufinder/domain/entities/item_type.dart'; 
import 'package:ajoufinder/domain/entities/location.dart'; 
import 'package:ajoufinder/domain/repository/board_repository.dart'; 
import 'package:ajoufinder/domain/repository/location_repository.dart'; 
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/views/conditions/condition_screen.dart'; 
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';  
import 'package:flutter/material.dart';  

class KeywordsSettingScreen extends StatefulWidget{
   const KeywordsSettingScreen({super.key});  
   
   @override State<KeywordsSettingScreen> createState() => _KeywordsSettingScreenState(); 
}  

class _KeywordsSettingScreenState extends State<KeywordsSettingScreen> { 
  List<Location> _selectedLocations = []; 
  List<ItemType> _selectedItemTypes = []; 
  List<String> _selectedStatuses = [];  

  List<Location> _availableLocations = []; 
  List<ItemType> _availableItemTypes = []; 
  List<String> _availableStatuses = [];  
  
  bool _isLoading = true; 
  String? _errorMessage;  

  Future<void> _loadData() async { 
    try { 
      _errorMessage = null;  
      final results = await Future.wait([
        _fetchLocations(), 
        _fetchItemTypes(), 
        _fetchStatuses(), 
      ]);  
      
      if (mounted) { 
        setState(() { 
          _availableLocations = results[0] as List<Location>; 
          _availableItemTypes = results[1] as List<ItemType>; 
          _availableStatuses = results[2] as List<String>; 
        }); 
      } 
    } catch (e) { 
      if (mounted) { 
        setState(() {
          _isLoading = false;
          _errorMessage = '데이터를 불러오는 중 오류가 발생했습니다: $e'; 
        }); 
      } 
    } finally { 
      if (mounted) { 
        setState(() { 
          _isLoading = false; 
        }); 
      } 
    } 
  }  
  
  @override void initState() { 
    super.initState(); 
    WidgetsBinding.instance.addPostFrameCallback((_) {
       _loadData(); 
      }); 
    }  
    
    Future<List<Location>> _fetchLocations() async { 
      final locationRepository = getIt<LocationRepository>(); 
      return locationRepository.getAllLocations(); 
    }  
    
    Future<List<ItemType>> _fetchItemTypes() async { 
      final boardRepository = getIt<BoardRepository>(); 
      return boardRepository.getAllItemTypes(); 
    }  
    
    Future<List<String>> _fetchStatuses() async { 
      final boardRepository = getIt<BoardRepository>(); 
      return boardRepository.getAllItemStatuses(); 
    }  
    
    @override Widget build(BuildContext context) {
      final theme = Theme.of(context);  

      return DefaultTabController(
        length: 2,
        child: Scaffold( 
          backgroundColor: theme.colorScheme.surface, 
          appBar: AppBar( 
            backgroundColor: theme.colorScheme.surface, 
            leading: IconButton( 
              icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface), 
              onPressed: () => Navigator.of(context).pop(), 
            ), 
            centerTitle: true, 
            title: Text( '관심 물품', style: TextStyle( color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold, ),
          ),
          bottom: TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.surfaceTint,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(text: '관심 물품 추가'),
              Tab(text: '관심 조건 리스트'),
            ],
          ),
        ), 
        body: TabBarView(
          children: [
            _buildBody(),
            ConditionScreen(),
          ]
        ),
      ),
    ); 
  }  
    
    Widget _buildBody() { 
      final theme = Theme.of(context);  
      
      if (_isLoading) { 
        return const Center(child: CircularProgressIndicator()); 
      }  
      
      if (_errorMessage != null) { 
        return Center( 
          child: Column( 
            mainAxisAlignment: MainAxisAlignment.center, 
            children: [ 
              Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error), 
              const SizedBox(height: 16), 
              Text(_errorMessage!, textAlign: TextAlign.center), 
              const SizedBox(height: 16), 
              ElevatedButton( 
                onPressed: () { 
                  setState(() { 
                    _isLoading = true; 
                    _errorMessage = null; 
                  });
                WidgetsBinding.instance.addPostFrameCallback((_) { 
                  _loadData(); 
                }); 
              }, 
              child: const Text('다시 시도'), 
            ), 
          ], 
        ), 
      );  
    }  
    
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(16), 
      child: Column( 
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [ 
          _buildConditionSection<Location>('관심 지역', _availableLocations, _selectedLocations,  
          (selected) => setState(() => _selectedLocations = selected)), 
          const SizedBox(height: 24),  

          _buildConditionSection<ItemType>('물품 종류', _availableItemTypes, _selectedItemTypes, 
          (selected) => setState(() => _selectedItemTypes = selected)), 
          const SizedBox(height: 24),  
          
          _buildConditionSection<String>('물품 상태', _availableStatuses, _selectedStatuses, 
          (selected) => setState(() => _selectedStatuses = selected)), 
          const SizedBox(height: 24),  
          
          SizedBox( 
            width: double.infinity, 
            child: ElevatedButton( 
              onPressed: () { 
                Navigator.of(context).pop(); 
              }, 
              child: Text('설정 저장', 
              style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.onPrimary)), 
            ), 
          ) 
        ], 
      ), 
    ); 
  }  
  
  Widget _buildConditionSection<T>(String title, List<T> availableItems, List<T> selectedItems, Function(List<T>) onChanged) { 
    final theme = Theme.of(context);  
    return Column( 
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [ 
        Text(title, style: theme.textTheme.titleMedium?.copyWith( fontWeight: FontWeight.bold) ), 
        const SizedBox(height: 8), 

        if (availableItems.isEmpty)  
        Text( '사용 가능한 항목이 없습니다.', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), ) 
        else  
        MultiSelectContainer<T>( 
          items: availableItems.map((item) => MultiSelectCard<T>( 
            value: item, 
            label: _getLabel(item), 
            ) 
          ).toList(),  
          onChange: (allSelectedItems, selectedItem) { 
            onChanged(allSelectedItems); 
          } 
        ), 
      ], 
    ); 
  }  
  
  String _getLabel<T>(item) { 
    if (item is Location) { 
      return item.locationName; 
    } else if (item is ItemType) { 
      return item.itemType; 
    } else{ 
      return item; 
    } 
  }
} 
  