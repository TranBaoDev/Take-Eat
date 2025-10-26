// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( LoadHomeData value)?  loadHomeData,TResult Function( LoadProducts value)?  loadProducts,required TResult orElse(),}){
final _that = this;
switch (_that) {
case LoadHomeData() when loadHomeData != null:
return loadHomeData(_that);case LoadProducts() when loadProducts != null:
return loadProducts(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( LoadHomeData value)  loadHomeData,required TResult Function( LoadProducts value)  loadProducts,}){
final _that = this;
switch (_that) {
case LoadHomeData():
return loadHomeData(_that);case LoadProducts():
return loadProducts(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( LoadHomeData value)?  loadHomeData,TResult? Function( LoadProducts value)?  loadProducts,}){
final _that = this;
switch (_that) {
case LoadHomeData() when loadHomeData != null:
return loadHomeData(_that);case LoadProducts() when loadProducts != null:
return loadProducts(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loadHomeData,TResult Function()?  loadProducts,required TResult orElse(),}) {final _that = this;
switch (_that) {
case LoadHomeData() when loadHomeData != null:
return loadHomeData();case LoadProducts() when loadProducts != null:
return loadProducts();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loadHomeData,required TResult Function()  loadProducts,}) {final _that = this;
switch (_that) {
case LoadHomeData():
return loadHomeData();case LoadProducts():
return loadProducts();case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loadHomeData,TResult? Function()?  loadProducts,}) {final _that = this;
switch (_that) {
case LoadHomeData() when loadHomeData != null:
return loadHomeData();case LoadProducts() when loadProducts != null:
return loadProducts();case _:
  return null;

}
}

}

/// @nodoc


class LoadHomeData implements HomeEvent {
  const LoadHomeData();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadHomeData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadHomeData()';
}


}




/// @nodoc


class LoadProducts implements HomeEvent {
  const LoadProducts();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadProducts);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.loadProducts()';
}


}




/// @nodoc
mixin _$HomeState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState()';
}


}

/// @nodoc
class $HomeStateCopyWith<$Res>  {
$HomeStateCopyWith(HomeState _, $Res Function(HomeState) __);
}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( HomeLoading value)?  loading,TResult Function( HomeLoaded value)?  loaded,TResult Function( HomeError value)?  error,TResult Function( ProductsLoaded value)?  productsLoaded,required TResult orElse(),}){
final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading(_that);case HomeLoaded() when loaded != null:
return loaded(_that);case HomeError() when error != null:
return error(_that);case ProductsLoaded() when productsLoaded != null:
return productsLoaded(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( HomeLoading value)  loading,required TResult Function( HomeLoaded value)  loaded,required TResult Function( HomeError value)  error,required TResult Function( ProductsLoaded value)  productsLoaded,}){
final _that = this;
switch (_that) {
case HomeLoading():
return loading(_that);case HomeLoaded():
return loaded(_that);case HomeError():
return error(_that);case ProductsLoaded():
return productsLoaded(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( HomeLoading value)?  loading,TResult? Function( HomeLoaded value)?  loaded,TResult? Function( HomeError value)?  error,TResult? Function( ProductsLoaded value)?  productsLoaded,}){
final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading(_that);case HomeLoaded() when loaded != null:
return loaded(_that);case HomeError() when error != null:
return error(_that);case ProductsLoaded() when productsLoaded != null:
return productsLoaded(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( String greeting)?  loaded,TResult Function( String error)?  error,TResult Function( List<Product> products)?  productsLoaded,required TResult orElse(),}) {final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading();case HomeLoaded() when loaded != null:
return loaded(_that.greeting);case HomeError() when error != null:
return error(_that.error);case ProductsLoaded() when productsLoaded != null:
return productsLoaded(_that.products);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( String greeting)  loaded,required TResult Function( String error)  error,required TResult Function( List<Product> products)  productsLoaded,}) {final _that = this;
switch (_that) {
case HomeLoading():
return loading();case HomeLoaded():
return loaded(_that.greeting);case HomeError():
return error(_that.error);case ProductsLoaded():
return productsLoaded(_that.products);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( String greeting)?  loaded,TResult? Function( String error)?  error,TResult? Function( List<Product> products)?  productsLoaded,}) {final _that = this;
switch (_that) {
case HomeLoading() when loading != null:
return loading();case HomeLoaded() when loaded != null:
return loaded(_that.greeting);case HomeError() when error != null:
return error(_that.error);case ProductsLoaded() when productsLoaded != null:
return productsLoaded(_that.products);case _:
  return null;

}
}

}

/// @nodoc


class HomeLoading implements HomeState {
  const HomeLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeState.loading()';
}


}




/// @nodoc


class HomeLoaded implements HomeState {
  const HomeLoaded(this.greeting);
  

 final  String greeting;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeLoadedCopyWith<HomeLoaded> get copyWith => _$HomeLoadedCopyWithImpl<HomeLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeLoaded&&(identical(other.greeting, greeting) || other.greeting == greeting));
}


@override
int get hashCode => Object.hash(runtimeType,greeting);

@override
String toString() {
  return 'HomeState.loaded(greeting: $greeting)';
}


}

/// @nodoc
abstract mixin class $HomeLoadedCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeLoadedCopyWith(HomeLoaded value, $Res Function(HomeLoaded) _then) = _$HomeLoadedCopyWithImpl;
@useResult
$Res call({
 String greeting
});




}
/// @nodoc
class _$HomeLoadedCopyWithImpl<$Res>
    implements $HomeLoadedCopyWith<$Res> {
  _$HomeLoadedCopyWithImpl(this._self, this._then);

  final HomeLoaded _self;
  final $Res Function(HomeLoaded) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? greeting = null,}) {
  return _then(HomeLoaded(
null == greeting ? _self.greeting : greeting // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class HomeError implements HomeState {
  const HomeError(this.error);
  

 final  String error;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeErrorCopyWith<HomeError> get copyWith => _$HomeErrorCopyWithImpl<HomeError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'HomeState.error(error: $error)';
}


}

/// @nodoc
abstract mixin class $HomeErrorCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $HomeErrorCopyWith(HomeError value, $Res Function(HomeError) _then) = _$HomeErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$HomeErrorCopyWithImpl<$Res>
    implements $HomeErrorCopyWith<$Res> {
  _$HomeErrorCopyWithImpl(this._self, this._then);

  final HomeError _self;
  final $Res Function(HomeError) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(HomeError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ProductsLoaded implements HomeState {
  const ProductsLoaded(final  List<Product> products): _products = products;
  

 final  List<Product> _products;
 List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsLoadedCopyWith<ProductsLoaded> get copyWith => _$ProductsLoadedCopyWithImpl<ProductsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsLoaded&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'HomeState.productsLoaded(products: $products)';
}


}

/// @nodoc
abstract mixin class $ProductsLoadedCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory $ProductsLoadedCopyWith(ProductsLoaded value, $Res Function(ProductsLoaded) _then) = _$ProductsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Product> products
});




}
/// @nodoc
class _$ProductsLoadedCopyWithImpl<$Res>
    implements $ProductsLoadedCopyWith<$Res> {
  _$ProductsLoadedCopyWithImpl(this._self, this._then);

  final ProductsLoaded _self;
  final $Res Function(ProductsLoaded) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(ProductsLoaded(
null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}


}

// dart format on
